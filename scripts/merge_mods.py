from __future__ import annotations

import collections
import os
import sys
import zipfile
from pathlib import Path, PurePosixPath

from toolkit_common import (
    EXPECTED_GAME_VERSION,
    EXPECTED_MOD_COUNT,
    GAME,
    SCHEMA_VERSION,
    SOURCE,
    game_version,
    git_commit,
    load_json,
    md,
    parsed_entries,
    repository,
    run_id,
    sha256,
    write_json,
    write_summary,
    validate_archive,
)

OUT = Path("merge-output")
OUTPUT = OUT / "Merged_Mods.zip"
MANIFEST = OUT / "MergeManifest.json"
REPORT = OUT / "MergeReport.md"

RULESET = "source-checked-five-group-v2"

RULES = [
    {
        "target": "this.tattoos = {};",
        "mods": [
            "KittyBuyOtherResidences.mod",
            "KittyPetNames.mod",
            "KittyPregnancyMod.mod",
        ],
    },
    {
        "target": "this.age = State.variables.pcage;",
        "mods": [
            "KittyBuyOtherResidences.mod",
            "KittyPetNames.mod",
            "KittyPregnancyMod.mod",
        ],
    },
    {
        "target": "//#endregion Clothing Management",
        "mods": [
            "KittyBuyOtherResidences.mod",
            "KittyPetNames.mod",
            "KittyPregnancyMod.mod",
        ],
    },
    {
        "target": "return [...new Set(inclins)];\n}",
        "mods": [
            "KittyBuyOtherResidences.mod",
            "KittyPregnancyMod.mod",
        ],
        "helper": True,
    },
    {
        "target": "&lt;&lt;set $pcage to 18&gt;&gt;",
        "mods": [
            "KittyBuyOtherResidences.mod",
            "KittyFollowers.mod",
            "KittyGoOverAnybodysHouse.mod",
            "KittyPetNames.mod",
            "KittyPregnancyMod.mod",
        ],
        "new_target": (
            "&lt;&lt;set $pcbirthday to setup.random_birthday()&gt;&gt;\n"
            "&lt;&lt;set $pcage to setup.minimum_pc_starting_age()&gt;&gt;"
        ),
        "startup": True,
    },
]


def fail(
    message: str,
    report_lines: list[str],
) -> int:

    for path in (
        OUTPUT,
        MANIFEST,
    ):
        path.unlink(
            missing_ok=True
        )

    report_lines += [
        "",
        "## Result",
        "",
        "- Status: **BLOCKED**",
        f"- {message}",
    ]

    REPORT.write_text(
        "\n".join(report_lines) + "\n",
        encoding="utf-8",
    )

    write_summary(
        f"# Merge\n\n"
        f"- **BLOCKED:** {message}"
    )

    print(
        message,
        file=sys.stderr,
    )

    return 1


def main() -> int:

    OUT.mkdir(
        parents=True,
        exist_ok=True,
    )

    report = [
        "# Reviewed Mod Merge",
        "",
        f"- Ruleset: `{RULESET}`",
        "- This build is manual-start. Candidate checking and "
        "patching are dependent automatic stages.",
        "",
    ]

    if (
        os.environ
        .get("INSPECTION_REVIEWED", "")
        .lower()
        != "true"
    ):
        return fail(
            "The manual inspection-review acknowledgment "
            "was not supplied.",
            report,
        )

    if (
        not SOURCE.is_file()
        or not GAME.is_file()
    ):
        return fail(
            "Mods.zip and CourseOfTemptation.html are both required.",
            report,
        )

    try:

        records = validate_archive(
            SOURCE
        )

        game = GAME.read_text(
            encoding="utf-8-sig"
        )

    except Exception as exc:

        return fail(
            f"Input validation failed: {exc}",
            report,
        )

    versions = game_version(
        game
    )

    if versions != [
        EXPECTED_GAME_VERSION
    ]:

        return fail(
            f"Ruleset {RULESET} requires "
            f"{EXPECTED_GAME_VERSION}; detected {versions}.",
            report,
        )

    mods = {}
    by_base = collections.defaultdict(list)

    for record in records:

        if not record["name"].lower().endswith(".mod"):
            continue

        try:

            text = (
                record["data"]
                .decode("utf-8-sig")
                .replace("\r\n", "\n")
            )

        except UnicodeError as exc:

            return fail(
                f"Invalid UTF-8 in {record['name']}: {exc}",
                report,
            )

        if "\r" in text:

            return fail(
                f"Standalone carriage return in {record['name']}.",
                report,
            )

        key = record["name"].casefold()

        mods[key] = {
            "name": record["name"],
            "bom": record["data"].startswith(
                b"\xef\xbb\xbf"
            ),
            "newline": (
                "\r\n"
                if b"\r\n" in record["data"]
                else "\n"
            ),
            "segments": text.split("~~"),
            "changed": False,
        }

        by_base[
            PurePosixPath(
                record["name"]
            ).name.casefold()
        ].append(key)

    if len(mods) != EXPECTED_MOD_COUNT:

        return fail(
            f"Expected {EXPECTED_MOD_COUNT} .mod files; "
            f"found {len(mods)}.",
            report,
        )

    inspection_path = (
        Path("inspection-bundle")
        / "InspectionData.json"
    )

    if not inspection_path.is_file():

        return fail(
            "The matching inspection artifact was not downloaded. "
            "Refusing to merge without a source-consistent inspection.",
            report,
        )

    try:

        inspection = load_json(
            inspection_path
        )

    except Exception as exc:

        return fail(
            f"Cannot read InspectionData.json: {exc}",
            report,
        )

    source_hash = sha256(
        SOURCE
    )

    game_hash = sha256(
        GAME
    )

    commit = git_commit()

    if (
        inspection.get("schema_version")
        != SCHEMA_VERSION
    ):

        return fail(
            "Inspection schema does not match this merger.",
            report,
        )

    if (
        inspection.get("checked_commit")
        != commit
    ):

        return fail(
            "Inspection commit does not match the selected build commit.",
            report,
        )

    if (
        inspection.get("source", {}).get("sha256")
        != source_hash
    ):

        return fail(
            "Inspection Mods.zip hash does not match the current input.",
            report,
        )

    if (
        inspection.get("game", {}).get("sha256")
        != game_hash
    ):

        return fail(
            "Inspection game hash does not match the current input.",
            report,
        )

    if inspection.get("status") == "BLOCKED":

        return fail(
            "The matching inspection is BLOCKED. "
            "Human acknowledgment cannot bypass a blocking inspection.",
            report,
        )

    def find_mod(
        basename: str,
    ) -> str:

        found = by_base[
            basename.casefold()
        ]

        if len(found) != 1:

            raise ValueError(
                f"Expected exactly one {basename}; "
                f"found {len(found)}"
            )

        return found[0]

    def all_entries():

        for key, mod in mods.items():

            for index, segment in enumerate(
                mod["segments"]
            ):

                if "~" not in segment:
                    continue

                old, new = segment.split(
                    "~",
                    1,
                )

                yield (
                    key,
                    index,
                    old.strip(),
                    new.strip(),
                )

    changed_files = set()
    changes = []
    effective_targets = []

    for rule in RULES:

        target = rule["target"]

        expected = [
            find_mod(name)
            for name in rule["mods"]
        ]

        found = [
            x
            for x in all_entries()
            if x[2] == target
        ]

        counts = collections.Counter(
            x[0]
            for x in found
        )

        if (
            set(counts) != set(expected)
            or any(
                counts[k] != 1
                for k in expected
            )
        ):

            owners = [
                mods[k]["name"]
                for k, *_ in found
            ]

            return fail(
                f"Rule ownership mismatch for "
                f"{target!r}; found owners: {owners}",
                report,
            )

        anchor = rule.get(
            "new_target",
            target,
        )

        if game.count(anchor) != 1:

            return fail(
                f"Expected exactly one original HTML match "
                f"for {anchor!r}; found {game.count(anchor)}",
                report,
            )

        lookup = {
            x[0]: x
            for x in found
        }

        tails = []

        for key in expected:

            _, _, old, replacement = lookup[key]

            if not replacement.startswith(old):

                return fail(
                    f"Replacement in {mods[key]['name']} "
                    f"does not retain its target anchor.",
                    report,
                )

            tail = replacement[
                len(old):
            ].strip()

            if not tail or "~" in tail:

                return fail(
                    f"Invalid empty/nested replacement tail "
                    f"in {mods[key]['name']}.",
                    report,
                )

            if rule.get("startup"):

                tail = tail.replace(
                    "&lt;&lt;set $pclastresidence&gt;&gt;",
                    '&lt;&lt;set $pclastresidence to ""&gt;&gt;',
                )

            if (
                rule.get("helper")
                and tail.rstrip().endswith("},")
            ):

                tail = (
                    tail.rstrip()[:-1]
                    + ";"
                )

            tails.append(tail)

        replacement = (
            anchor
            + "\n\n"
            + "\n\n".join(tails)
        )

        keeper = expected[-1]

        for key in expected:

            _, index, _, _ = lookup[key]

            mods[key]["segments"][index] = (
                "\n"
                + anchor
                + "\n~\n"
                + replacement
                + "\n"
                if key == keeper
                else ""
            )

            mods[key]["changed"] = True

            changed_files.add(
                mods[key]["name"]
            )

        effective_targets.append(
            anchor
        )

        changes.append(
            {
                "original_target": target,
                "output_anchor": anchor,
                "combined_mods": rule["mods"],
                "stored_in": mods[keeper]["name"],
            }
        )

    remaining = list(
        all_entries()
    )

    for target in effective_targets:

        if (
            sum(
                old == target
                for _, _, old, _
                in remaining
            )
            != 1
        ):

            return fail(
                f"Post-merge validation failed: "
                f"expected one surviving {target!r}.",
                report,
            )

    if any(
        old == RULES[-1]["target"]
        for _, _, old, _
        in remaining
    ):

        return fail(
            "Obsolete fixed-age startup target survived the merge.",
            report,
        )

    original_by_key = {
        r["name"].casefold(): r
        for r in records
    }

    for key, mod in mods.items():

        if not mod["changed"]:
            continue

        text = "~~".join(
            mod["segments"]
        )

        data = (
            text
            .replace(
                "\n",
                mod["newline"],
            )
            .encode("utf-8")
        )

        if mod["bom"]:
            data = (
                b"\xef\xbb\xbf"
                + data
            )

        original_by_key[key]["data"] = data

    with zipfile.ZipFile(
        OUTPUT,
        "w",
        compression=zipfile.ZIP_DEFLATED,
    ) as zf:

        for key in sorted(
            original_by_key
        ):

            zf.writestr(
                original_by_key[key]["name"],
                original_by_key[key]["data"],
            )

    try:

        output_records = validate_archive(
            OUTPUT
        )

    except Exception as exc:

        return fail(
            f"Generated candidate failed ZIP validation: {exc}",
            report,
        )

    output_mods = [
        r
        for r in output_records
        if r["name"].lower().endswith(".mod")
    ]

    if len(output_mods) != EXPECTED_MOD_COUNT:

        return fail(
            f"Generated candidate contains "
            f"{len(output_mods)} .mod files; "
            f"expected {EXPECTED_MOD_COUNT}.",
            report,
        )

    if (
        sha256(SOURCE) != source_hash
        or sha256(GAME) != game_hash
    ):

        return fail(
            "Original inputs changed during merging.",
            report,
        )

    candidate_hash = sha256(
        OUTPUT
    )

    program_hash = sha256(
        Path(__file__)
    )

    manifest = {
        "schema_version": SCHEMA_VERSION,
        "candidate_status": "diagnostic_candidate",
        "ruleset": RULESET,
        "game_version": EXPECTED_GAME_VERSION,
        "repository": repository(),
        "workflow_run_id": run_id(),
        "checked_commit": commit,
        "source": {
            "filename": SOURCE.name,
            "sha256": source_hash,
        },
        "game": {
            "filename": GAME.name,
            "sha256": game_hash,
        },
        "candidate": {
            "filename": OUTPUT.name,
            "sha256": candidate_hash,
        },
        "merge_program_sha256": program_hash,
        "inspection": {
            "schema_version": inspection.get(
                "schema_version"
            ),
            "status": inspection.get(
                "status"
            ),
            "checked_commit": inspection.get(
                "checked_commit"
            ),
            "source_sha256": inspection.get(
                "source",
                {},
            ).get("sha256"),
            "game_sha256": inspection.get(
                "game",
                {},
            ).get("sha256"),
        },
        "mod_count": len(output_mods),
        "changed_files": sorted(
            changed_files
        ),
        "merged_groups": changes,
        "patcher_executed": False,
        "gameplay_verified": False,
    }

    write_json(
        MANIFEST,
        manifest,
    )

    report += [
        "## Inputs",
        "",
        f"- Commit: `{commit}`",
        f"- Mods SHA-256: `{source_hash}`",
        f"- Game SHA-256: `{game_hash}`",
        f"- Inspection status: **{inspection.get('status')}**",
        "",
        "## Candidate",
        "",
        f"- `Merged_Mods.zip` SHA-256: `{candidate_hash}`",
        f"- Mod files retained: **{len(output_mods)}**",
        f"- Approved merge groups: **{len(changes)}**",
        f"- Changed mod files: **{len(changed_files)}**",
        "",
        "## Rules applied",
        "",
    ]

    report += [
        f"- `{md(c['original_target'])}` "
        f"→ stored in `{md(c['stored_in'])}`"
        for c in changes
    ]

    report += [
        "",
        "## Important limits",
        "",
        "- This ruleset contains only source-reviewed "
        "transformations already established for the current baseline.",
        "- It does not claim that the remaining 52-mod set "
        "is fully compatible.",
        "- The candidate is diagnostic until candidate inspection "
        "and KittyPatcher complete.",
        "- Gameplay remains unverified.",
        "",
    ]

    REPORT.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    write_summary(
        "# Merge\n\n"
        "- **CANDIDATE CREATED**\n"
        f"- Ruleset: `{RULESET}`\n"
        f"- Candidate SHA-256: `{candidate_hash}`\n"
        f"- Inspection: `{inspection.get('status')}`"
    )

    print(
        f"Created {OUTPUT} "
        f"({len(output_mods)} mods)."
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())
