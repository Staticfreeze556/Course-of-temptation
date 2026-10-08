import collections
import hashlib
import html
import json
import os
import re
import subprocess
import zipfile
from pathlib import Path, PurePosixPath

EXPECTED_VERSION = "v0.8.4d"
EXPECTED_MOD_COUNT = 52
RULESET = "five-shared-groups-v1"

SOURCE = Path("Mods.zip")
GAME = Path("CourseOfTemptation.html")
OUTPUT_DIR = Path("merge-output")
OUTPUT_ZIP = OUTPUT_DIR / "Merged_Mods.zip"
MANIFEST_PATH = OUTPUT_DIR / "MergeManifest.json"
REPORT_PATH = OUTPUT_DIR / "MergeReport.md"

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

changes = []
changed_paths = set()
effective_targets = []

report = [
    "# Reviewed Mod Merge",
    "",
    f"- Ruleset: {RULESET}",
    "- Build trigger: manual only.",
    "- Input inspection must be reviewed before starting this build.",
    "- Candidate inspection and patching follow automatically if checks allow.",
    "",
]


import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from kitty_escape import (  # noqa: E402
    ModFormatError,
    extract_add_passages,
    passage_block,
    pre_escape_replace_blocks,
    validate_passages,
)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_report(status, message):
    text = "\n".join(
        report + [
            "",
            "## Merge-stage result",
            "",
            f"- Status: {status}",
            f"- {message}",
            "",
        ]
    ) + "\n"

    REPORT_PATH.write_text(text, encoding="utf-8")

    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary_path:
        with open(summary_path, "a", encoding="utf-8") as output:
            output.write(text)


def fail(message):
    for path in (OUTPUT_ZIP, MANIFEST_PATH):
        if path.exists():
            path.unlink()

    write_report("BLOCKED", message)
    raise SystemExit(message)


def merge():
    for path in (OUTPUT_ZIP, MANIFEST_PATH):
        if path.exists():
            path.unlink()

    if not SOURCE.is_file():
        fail(
            "Mods.zip is missing. Complete preparation and inspection first."
        )

    if not GAME.is_file():
        fail(
            "CourseOfTemptation.html is missing from the repository root."
        )

    source_hash = sha(SOURCE)
    game_hash = sha(GAME)
    program_hash = sha(Path(__file__))

    checked_commit = subprocess.check_output(
        ["git", "rev-parse", "HEAD"],
        text=True,
    ).strip()

    game = GAME.read_text(encoding="utf-8-sig")
    decoded_game = html.unescape(game)

    versions = sorted(set(re.findall(
        r'Config\.saves\.version\s*(?:=|to)\s*'
        r'["\'](v[^"\'\s<>]+)["\']',
        decoded_game,
    )))

    if versions != [EXPECTED_VERSION]:
        fail(
            f"Rules require {EXPECTED_VERSION}; found {versions}. "
            "Review the inspection report and update the merge rules."
        )

    records = {}

    with zipfile.ZipFile(SOURCE) as archive:
        bad_file = archive.testzip()

        if bad_file is not None:
            fail(
                f"Original ZIP integrity check failed at: {bad_file}"
            )

        for info in archive.infolist():
            if info.is_dir():
                continue

            name = info.filename.replace("\\", "/")
            path = PurePosixPath(name)

            if (
                path.is_absolute()
                or ".." in path.parts
                or (path.parts and ":" in path.parts[0])
            ):
                fail(f"Unsafe archive path: {name}")

            if (
                "__MACOSX" in path.parts
                or path.name.startswith("._")
            ):
                continue

            key = name.casefold()

            if key in records:
                fail(
                    f"Duplicate case-insensitive archive path: {name}"
                )

            records[key] = {
                "name": name,
                "data": archive.read(info),
            }

    mods = {}
    by_basename = collections.defaultdict(list)

    for key, record in records.items():
        if not record["name"].lower().endswith(".mod"):
            continue

        raw = record["data"]
        text = raw.decode("utf-8-sig").replace("\r\n", "\n")

        if "\r" in text:
            fail(
                f"Standalone carriage return in {record['name']}. "
                "Review the input format before merging."
            )

        mods[key] = {
            "name": record["name"],
            "bom": raw.startswith(b"\xef\xbb\xbf"),
            "newline": "\r\n" if b"\r\n" in raw else "\n",
            "segments": text.split("~~"),
            "changed": False,
        }

        basename = PurePosixPath(
            record["name"]
        ).name.casefold()

        by_basename[basename].append(key)

    if len(mods) != EXPECTED_MOD_COUNT:
        fail(
            f"Rules expect {EXPECTED_MOD_COUNT} mod files; "
            f"found {len(mods)}. Review the report and update the rules "
            "rather than bypassing this check."
        )

    report.extend([
        "## Inputs",
        "",
        f"- Checked commit: {checked_commit}",
        f"- Original archive: {SOURCE}",
        f"- Original archive SHA256: {source_hash}",
        f"- Original HTML: {GAME}",
        f"- Original HTML SHA256: {game_hash}",
        f"- Merge program SHA256: {program_hash}",
        f"- Game version: {EXPECTED_VERSION}",
        f"- Mod files: {len(mods)}",
        "",
    ])

    def find_mod(basename):
        matches = by_basename[basename.casefold()]

        if len(matches) != 1:
            fail(
                f"Expected exactly one {basename}; "
                f"found {len(matches)}."
            )

        return matches[0]

    def entries():
        for key, mod in mods.items():
            for index, segment in enumerate(mod["segments"]):
                if "~" in segment:
                    old, new = segment.split("~", 1)
                    yield key, index, old.strip(), new.strip()

    def merge_target(
        target,
        basenames,
        new_target=None,
        startup=False,
        helper=False,
    ):
        expected = [
            find_mod(name) for name in basenames
        ]

        found = [
            entry for entry in entries()
            if entry[2] == target
        ]

        counts = collections.Counter(
            entry[0] for entry in found
        )

        if (
            set(counts) != set(expected)
            or any(counts[key] != 1 for key in expected)
        ):
            owners = [
                mods[key]["name"]
                for key, _, _, _ in found
            ]

            fail(
                f"Rule ownership mismatch for {target!r}. "
                f"Owners found: {owners}. Update this rule from the "
                "inspection report and original source."
            )

        anchor = (
            new_target if new_target is not None else target
        )

        count = game.count(anchor)

        if count != 1:
            fail(
                f"Expected one original HTML match for {anchor!r}; "
                f"found {count}."
            )

        lookup = {
            entry[0]: entry for entry in found
        }

        tails = []

        for key in expected:
            _, index, old, replacement = lookup[key]

            if not replacement.startswith(old):
                fail(
                    "Replacement does not retain its anchor: "
                    f"{mods[key]['name']}, {target!r}"
                )

            tail = replacement[len(old):].strip()

            if not tail or "~" in tail:
                fail(
                    "Empty addition or unexpected separator in "
                    f"{mods[key]['name']}."
                )

            if startup:
                tail = tail.replace(
                    "&lt;&lt;set $pclastresidence&gt;&gt;",
                    '&lt;&lt;set $pclastresidence to ""&gt;&gt;',
                )

            if helper and tail.rstrip().endswith("},"):
                tail = tail.rstrip()[:-1] + ";"

            tails.append(tail)

        replacement = (
            anchor + "\n\n" + "\n\n".join(tails)
        )

        keeper = expected[-1]

        for key in expected:
            _, index, _, _ = lookup[key]

            mods[key]["segments"][index] = (
                "\n" + anchor + "\n~\n" + replacement + "\n"
                if key == keeper else ""
            )

            mods[key]["changed"] = True
            changed_paths.add(mods[key]["name"])

        effective_targets.append(anchor)

        changes.append({
            "original_target": target,
            "output_anchor": anchor,
            "combined_mods": basenames,
            "stored_in": mods[keeper]["name"],
            "original_match_count": count,
        })

    trio = [
        "KittyBuyOtherResidences.mod",
        "KittyPetNames.mod",
        "KittyPregnancyMod.mod",
    ]

    merge_target(
        "this.tattoos = {};",
        trio,
    )

    merge_target(
        "this.age = State.variables.pcage;",
        trio,
    )

    merge_target(
        "//#endregion Clothing Management",
        trio,
    )

    merge_target(
        "return [...new Set(inclins)];\n}",
        [
            "KittyBuyOtherResidences.mod",
            "KittyPregnancyMod.mod",
        ],
        helper=True,
    )

    obsolete_startup = (
        "&lt;&lt;set $pcage to 18&gt;&gt;"
    )

    startup_anchor = (
        "&lt;&lt;set $pcbirthday to setup.random_birthday()&gt;&gt;\n"
        "&lt;&lt;set $pcage to setup.minimum_pc_starting_age()&gt;&gt;"
    )

    merge_target(
        obsolete_startup,
        [
            "KittyBuyOtherResidences.mod",
            "KittyFollowers.mod",
            "KittyGoOverAnybodysHouse.mod",
            "KittyPetNames.mod",
            "KittyPregnancyMod.mod",
        ],
        new_target=startup_anchor,
        startup=True,
    )

    remaining = list(entries())

    for target in effective_targets:
        count = sum(
            old == target
            for _, _, old, _ in remaining
        )

        if count != 1:
            fail(
                f"Post-merge validation failed for {target!r}: "
                f"{count} surviving entries."
            )

    if any(
        old == obsolete_startup
        for _, _, old, _ in remaining
    ):
        fail(
            "Obsolete fixed-age startup target remains."
        )

    pre_escaped = {}
    added_passages = []
    inferred_blocks = []
    passage_owners = []

    for key, mod in mods.items():
        text = "~~".join(mod["segments"])

        if "Add Passage:" in text or "Add Javascript:" in text:
            try:
                text, passages, inferred = extract_add_passages(text)
            except ModFormatError as exc:
                fail(f"{mod['name']}: {exc}")
            passage_owners.append(mod["name"])
            if len(passage_owners) > 1:
                fail(
                    "Add Passage: found in more than one mod "
                    f"({passage_owners}); combining insertions is not implemented."
                )
            errors = validate_passages(passages, game)
            if errors:
                fail(f"{mod['name']}: " + "; ".join(errors))
            text += passage_block(passages)
            for p in passages:
                added_passages.append({
                    "mod": mod["name"],
                    "name": p["name"],
                    "pid": p["pid"],
                    "tags": p["tags"],
                    "body_sha256": hashlib.sha256(p["body"].encode("utf-8")).hexdigest(),
                })
            for target in inferred:
                inferred_blocks.append({
                    "mod": mod["name"],
                    "target": target[:200],
                    "note": "r:/w: treated as Replace:/With: (inferred; owner-approved, "
                            "not confirmed by patcher source)",
                })
            mod["changed"] = True
            changed_paths.add(mod["name"])

        text, converted = pre_escape_replace_blocks(text)

        if converted:
            pre_escaped[mod["name"]] = converted
            mod["changed"] = True
            changed_paths.add(mod["name"])

        if not mod["changed"]:
            continue

        text = text.replace("\n", mod["newline"])
        data = text.encode("utf-8")

        if mod["bom"]:
            data = b"\xef\xbb\xbf" + data

        records[key]["data"] = data

    with zipfile.ZipFile(
        OUTPUT_ZIP,
        "w",
        compression=zipfile.ZIP_DEFLATED,
    ) as archive:
        for key in sorted(records):
            record = records[key]

            archive.writestr(
                record["name"],
                record["data"],
            )

    with zipfile.ZipFile(OUTPUT_ZIP) as archive:
        bad_file = archive.testzip()

        output_count = sum(
            name.lower().endswith(".mod")
            for name in archive.namelist()
        )

        if (
            bad_file is not None
            or output_count != EXPECTED_MOD_COUNT
        ):
            fail(
                "Output ZIP integrity or mod-count validation failed."
            )

        for record in records.values():
            if (
                archive.read(record["name"])
                != record["data"]
            ):
                fail(
                    f"Output content mismatch: {record['name']}"
                )

    if (
        sha(SOURCE) != source_hash
        or sha(GAME) != game_hash
    ):
        fail(
            "An original input unexpectedly changed during merging."
        )

    owners = collections.defaultdict(set)

    for key, index, old, new in remaining:
        owners[old].add(mods[key]["name"])

    shared = [
        {
            "target": target,
            "files": sorted(names),
        }
        for target, names in owners.items()
        if len(names) > 1
    ]

    output_hash = sha(OUTPUT_ZIP)

    manifest = {
        "schema_version": 1,
        "candidate_status": "diagnostic_candidate",
        "ruleset": RULESET,
        "game_version": EXPECTED_VERSION,
        "mod_count": output_count,
        "repository": os.environ.get("GITHUB_REPOSITORY"),
        "workflow_run_id": os.environ.get("GITHUB_RUN_ID"),
        "workflow_run_number": os.environ.get("GITHUB_RUN_NUMBER"),
        "checked_commit": checked_commit,
        "merge_program_sha256": program_hash,
        "merge_helper_sha256": sha(Path(__file__).resolve().parent / "kitty_escape.py"),
        "source": {
            "filename": SOURCE.name,
            "sha256": source_hash,
        },
        "game": {
            "filename": GAME.name,
            "sha256": game_hash,
        },
        "candidate": {
            "filename": OUTPUT_ZIP.name,
            "sha256": output_hash,
        },
        "merged_groups": changes,
        "pre_escaped_replace_blocks": pre_escaped,
        "added_passages": added_passages,
        "inferred_replace_blocks": inferred_blocks,
        "changed_files": sorted(changed_paths),
        "remaining_shared_targets": shared,
        "inspection_review": (
            "Manual prerequisite; no inspection artifact was "
            "verified by this program."
        ),
        "patcher_executed": False,
        "gameplay_verified": False,
    }

    MANIFEST_PATH.write_text(
        json.dumps(
            manifest,
            indent=2,
            ensure_ascii=False,
        ) + "\n",
        encoding="utf-8",
    )

    report.extend([
        "## Candidate",
        "",
        f"- Filename: {OUTPUT_ZIP.name}",
        f"- SHA256: {output_hash}",
        f"- Mod files retained: {output_count}",
        f"- Groups merged: {len(changes)}",
        f"- Files changed: {len(changed_paths)}",
        f"- Remaining shared targets: {len(shared)}",
        "- Original archive and original HTML were not modified.",
        "",
        "## Changed files",
        "",
        *[
            f"- {name}"
            for name in sorted(changed_paths)
        ],
        "",
        "## Merged groups",
        "",
    ])

    for change in changes:
        report.extend([
            f"- Original target: {change['original_target']!r}",
            f"  - Output anchor: {change['output_anchor']!r}",
            f"  - Combined mods: {', '.join(change['combined_mods'])}",
            f"  - Stored in: {change['stored_in']}",
        ])

    report.extend([
        "",
        "## Explicit adjustments",
        "",
        "- Retain the game's calculated starting age.",
        "- Set bare pclastresidence initialization to an empty string.",
        "  This is an unset sentinel, not a validated destination.",
        "- Change a trailing comma to a semicolon in the helper addition.",
        "- Pre-escape Replace:/With: blocks that contain raw <<macros>>, as",
        "  KittyPatcher v0.1.2 would, but without double-escaping existing",
        "  entities (works around its &quot; -> &amp;quot; conversion).",
        *[f"  - {name}: {n} blocks" for name, n in sorted(pre_escaped.items())],
        "- Own-line <e>...</e> content escaped and marker lines removed.",
        f"- Add Passage: sections moved out of Replace blocks and inserted before "
        f"</tw-storydata> as {len(added_passages)} passages:",
        *[f"  - {p['name']} (pid {p['pid']}, {p['mod']})" for p in added_passages],
        *[f"- INFERRED r:/w: block treated as Replace:/With: in {b['mod']}: {b['target'][:80]!r}"
          for b in inferred_blocks],
        "",
        "## Not repaired by this ruleset",
        "",
        "- Monthly rent-call whitespace mismatch.",
        "- Missing rent-event registration anchor.",
        "- Calendar assignment or variable defect.",
        "- Rent state synchronization.",
        "- Mismatched rental-action strings.",
        "- Other failed residence location replacements.",
        "- Remaining shared targets and other mod failures.",
        "- New findings from future inspection reports.",
        "",
        "## Remaining shared targets",
        "",
    ])

    if shared:
        for item in shared:
            target = re.sub(
                r"\s+",
                " ",
                item["target"],
            )

            if len(target) > 160:
                target = target[:160] + "..."

            report.append(
                f"- {target!r}: {', '.join(item['files'])}"
            )
    else:
        report.append(
            "- None in the parsed ~~ / ~ entries."
        )

    report.extend([
        "",
        "## Review and validation limits",
        "",
        "- This program does not retrieve the original inspection report.",
        "- Compare these input hashes with the inspection you reviewed.",
        "- Matching merge prerequisites do not certify compatibility.",
        "- The manifest describes the candidate at the end of merging.",
        "- Its patcher_executed value is false because patching is a later stage.",
        "- Gameplay has not been verified.",
        "",
        "## What happens next",
        "",
        "- The workflow uploads Merged_Mods.zip and MergeManifest.json.",
        "- The dependent job downloads this exact candidate artifact.",
        "- Candidate inspection checks the manifest, hashes, and mod structure.",
        "- Blocking findings stop patching.",
        "- Review warnings stop patching unless acknowledged at build start.",
        "- If checks allow it, KittyPatcher runs automatically.",
        "- Final patch reports and the diagnostic game are separate artifacts.",
        "- No manual Run ID entry or candidate reupload is required.",
        "",
        f"- Build Run ID: {os.environ.get('GITHUB_RUN_ID', 'unknown')}",
        "",
    ])

    write_report(
        "CANDIDATE CREATED",
        "Merged_Mods.zip and its manifest were created. "
        "Candidate inspection and patching follow automatically "
        "within this manually started build if the checks allow.",
    )

    print(
        f"Created {OUTPUT_ZIP.name}: "
        f"{output_count} mods, "
        f"{len(changes)} merged groups, "
        f"{len(shared)} remaining shared targets."
    )


if __name__ == "__main__":
    try:
        merge()
    except SystemExit:
        raise
    except Exception as exc:
        fail(
            f"Merge failed: {type(exc).__name__}: {exc}"
        )
