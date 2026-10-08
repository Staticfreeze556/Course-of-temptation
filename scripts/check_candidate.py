from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

from toolkit_common import (
    EXPECTED_MOD_COUNT,
    GAME,
    SOURCE,
    load_json,
    sha256,
    validate_archive,
    write_summary,
)

CANDIDATE_DIR = Path("work/_candidate")
ARCHIVE = CANDIDATE_DIR / "Merged_Mods.zip"
MANIFEST = CANDIDATE_DIR / "MergeManifest.json"
REPORT = Path("work/CandidateInspection.md")


def main() -> int:

    blockers = []
    warnings = []
    details = []

    for path in (
        ARCHIVE,
        MANIFEST,
        SOURCE,
        GAME,
    ):

        if not path.is_file():

            blockers.append(
                f"Required file missing: {path}"
            )

    if blockers:
        return finish(
            blockers,
            warnings,
            details,
        )

    try:

        manifest = load_json(
            MANIFEST
        )

        candidate_records = validate_archive(
            ARCHIVE
        )

        source_records = validate_archive(
            SOURCE
        )

    except Exception as exc:

        blockers.append(
            f"Candidate/input validation failed: {exc}"
        )

        return finish(
            blockers,
            warnings,
            details,
        )

    commit = subprocess.check_output(
        [
            "git",
            "rev-parse",
            "HEAD",
        ],
        text=True,
    ).strip()

    source_hash = sha256(
        SOURCE
    )

    game_hash = sha256(
        GAME
    )

    candidate_hash = sha256(
        ARCHIVE
    )

    checks = [
        (
            manifest.get(
                "candidate_status"
            )
            == "diagnostic_candidate",
            "Manifest does not identify a diagnostic candidate.",
        ),
        (
            manifest.get(
                "checked_commit"
            )
            == commit,
            "Candidate was built from a different repository commit.",
        ),
        (
            manifest.get(
                "source",
                {},
            ).get("sha256")
            == source_hash,
            "Candidate manifest source hash does not match Mods.zip.",
        ),
        (
            manifest.get(
                "game",
                {},
            ).get("sha256")
            == game_hash,
            "Candidate manifest game hash does not match CourseOfTemptation.html.",
        ),
        (
            manifest.get(
                "candidate",
                {},
            ).get("sha256")
            == candidate_hash,
            "Candidate archive hash does not match its manifest.",
        ),
        (
            manifest.get(
                "candidate",
                {},
            ).get("filename")
            == ARCHIVE.name,
            "Candidate filename is not Merged_Mods.zip.",
        ),
    ]

    for ok, message in checks:

        if not ok:
            blockers.append(message)

    source_mods = sorted(
        r["name"].casefold()
        for r in source_records
        if r["name"].lower().endswith(".mod")
    )

    candidate_mods = sorted(
        r["name"].casefold()
        for r in candidate_records
        if r["name"].lower().endswith(".mod")
    )

    if len(candidate_mods) != EXPECTED_MOD_COUNT:

        blockers.append(
            f"Candidate contains {len(candidate_mods)} "
            f".mod files; expected {EXPECTED_MOD_COUNT}."
        )

    if candidate_mods != source_mods:

        blockers.append(
            "Candidate .mod filename set differs "
            "from the original archive."
        )

    inspection = manifest.get(
        "inspection",
        {},
    )

    if (
        inspection.get(
            "source_sha256"
        )
        != source_hash
        or inspection.get(
            "game_sha256"
        )
        != game_hash
    ):

        blockers.append(
            "Candidate is not bound to the same "
            "inspected input hashes."
        )

    if (
        inspection.get(
            "checked_commit"
        )
        != commit
    ):

        blockers.append(
            "Candidate inspection binding does not "
            "match the current commit."
        )

    if (
        inspection.get("status")
        == "BLOCKED"
    ):

        blockers.append(
            "The source inspection was BLOCKED; "
            "candidate patching cannot proceed."
        )

    for record in candidate_records:

        if not record["name"].lower().endswith(".mod"):
            continue

        try:

            text = (
                record["data"]
                .decode("utf-8-sig")
            )

        except UnicodeError as exc:

            blockers.append(
                f"{record['name']}: invalid UTF-8: {exc}"
            )

            continue

        if (
            "Replace:" in text
            or "Add Passage:" in text
            or "<e>" in text
        ):

            warnings.append(
                f"{record['name']}: contains patch syntax "
                "outside the candidate checker parser."
            )

    details += [
        f"- Checked commit: `{commit}`",
        f"- Mods SHA-256: `{source_hash}`",
        f"- Game SHA-256: `{game_hash}`",
        f"- Candidate SHA-256: `{candidate_hash}`",
        f"- Candidate mod files: **{len(candidate_mods)}**",
        f"- Inspection status recorded in manifest: "
        f"**{inspection.get('status', 'unknown')}**",
    ]

    return finish(
        blockers,
        warnings,
        details,
    )


def finish(
    blockers,
    warnings,
    details,
) -> int:

    status = (
        "BLOCKED"
        if blockers
        else
        "REVIEW REQUIRED"
        if warnings
        else
        "STATIC CHECKS PASSED"
    )

    report = [
        "# Merged Candidate Inspection",
        "",
        f"- Status: **{status}**",
        f"- Blocking findings: **{len(blockers)}**",
        f"- Review warnings: **{len(warnings)}**",
        "",
        "## Build identity",
        "",
    ]

    report += details

    report += [
        "",
        "## Blocking findings",
        "",
    ]

    report += (
        [f"- {x}" for x in blockers]
        or ["- None."]
    )

    report += [
        "",
        "## Review warnings",
        "",
    ]

    report += (
        [f"- {x}" for x in warnings]
        or ["- None."]
    )

    report += [
        "",
        "## Interpretation",
        "",
        "- Passing this checker means the candidate is structurally "
        "and provenance-consistent with the reviewed inputs.",
        "- It does not prove every replacement is semantically correct.",
        "- It does not execute KittyPatcher.",
        "- It does not validate gameplay.",
    ]

    REPORT.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    REPORT.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    write_summary(
        "# Candidate preflight\n\n"
        f"- **{status}**\n"
        f"- Blockers: {len(blockers)}\n"
        f"- Warnings: {len(warnings)}"
    )

    if blockers:
        return 1

    if (
        warnings
        and os.environ.get(
            "ACCEPT_STATIC_WARNINGS",
            ""
        ).lower()
        != "true"
    ):
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
