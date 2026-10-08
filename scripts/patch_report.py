from __future__ import annotations

import hashlib
import os
import re
from pathlib import Path

from toolkit_common import (
    write_output,
    write_summary,
)

GAME = Path(
    os.environ.get(
        "PATCHED_GAME_PATH",
        "work/CourseOfTemptation.html",
    )
)

MODS = Path("work/mods")
REPORT = Path(
    "work/StructuredPatchReport.md"
)


def sha(path: Path) -> str:

    h = hashlib.sha256()

    with path.open("rb") as fh:

        for chunk in iter(
            lambda: fh.read(1024 * 1024),
            b"",
        ):

            h.update(chunk)

    return h.hexdigest()


def main() -> int:

    if not GAME.is_file():
        raise SystemExit(
            "Patched game output is missing."
        )

    logs = (
        sorted(
            MODS.rglob("*.txt")
        )
        if MODS.is_dir()
        else []
    )

    log_text = "\n".join(
        p.read_text(
            encoding="utf-8",
            errors="replace",
        )
        for p in logs
    )

    made = first_int(
        log_text,
        r"Total replacements made:\s*(\d+)",
    )

    failed = first_int(
        log_text,
        r"Total replacements failed:\s*(\d+)",
    )

    no_match = len(
        re.findall(
            r"No match found",
            log_text,
            re.I,
        )
    )

    mods = (
        sorted(
            p.relative_to(MODS).as_posix()
            for p in MODS.rglob("*.mod")
        )
        if MODS.is_dir()
        else []
    )

    game_hash = sha(
        GAME
    )

    original_hash = os.environ.get(
        "ORIGINAL_GAME_SHA256",
        "",
    )

    status = (
        "PATCHER REPORTED FAILURES"
        if failed
        else
        "PATCHER COMPLETED WITH UNVERIFIED RESULTS"
    )

    if (
        made is None
        and failed is None
    ):

        status = (
            "PATCHER COMPLETION "
            "UNCONFIRMED FROM LOGS"
        )

    report = [
        "# Patch report",
        "",
        f"- Status: **{status}**",
        f"- Merge Run ID: `{os.environ.get('MERGE_RUN_ID', 'unknown')}`",
        f"- Patcher release tag: `{os.environ.get('PATCHER_RELEASE_TAG', 'unknown')}`",
        f"- Patched game SHA-256: `{game_hash}`",
        f"- Original game SHA-256: "
        f"`{original_hash or 'not supplied'}`",
        f"- Mod files presented to patcher: **{len(mods)}**",
        f"- Patcher replacements made: "
        f"**{made if made is not None else 'unknown'}**",
        f"- Patcher replacements failed: "
        f"**{failed if failed is not None else 'unknown'}**",
        f"- Logged 'No match found' messages: **{no_match}**",
        "",
        "## What this proves",
        "",
        "- The patcher process was invoked by the workflow "
        "if this report step ran.",
        "- The report records what the available patcher logs say.",
        "- The generated HTML has a recorded hash for reproducibility.",
        "",
        "## What this does not prove",
        "",
        "- A successful process exit does not prove every mod "
        "replacement applied.",
        "- Log counts do not prove semantic correctness of each replacement.",
        "- This report does not validate JavaScript/SugarCube "
        "behavior after patching.",
        "- Gameplay remains unverified.",
        "",
        "## Raw log inventory",
        "",
    ]

    report += (
        [
            f"- `{p.relative_to(MODS).as_posix()}`"
            for p in logs
        ]
        or ["- No text logs were found."]
    )

    if no_match:

        report += [
            "",
            "## Interpretation of missing matches",
            "",
            "The patcher logs contain one or more `No match found` "
            "messages. Review the raw logs and the candidate inspection "
            "before treating the build as usable.",
        ]

    if (
        made is not None
        and failed is not None
        and failed == 0
    ):

        report += [
            "",
            "## Patcher totals",
            "",
            "The patcher log reports zero failed replacements. "
            "This is still diagnostic rather than gameplay verification.",
        ]

    REPORT.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    if made is not None:

        badge = (
            f"Diagnostic patch complete: "
            f"{made} replacements reported, "
            f"{failed} failures reported; "
            f"gameplay unverified."
        )

    else:

        badge = (
            "Diagnostic patch completed; "
            "patcher totals unavailable; "
            "gameplay unverified."
        )

    write_output(
        "badge",
        badge,
    )

    write_summary(
        "# Patch results\n\n"
        f"- Status: **{status}**\n"
        f"- Reported made: "
        f"{made if made is not None else 'unknown'}\n"
        f"- Reported failed: "
        f"{failed if failed is not None else 'unknown'}\n"
        f"- No-match log lines: {no_match}\n"
        "- Gameplay remains unverified."
    )

    return 0


def first_int(
    text: str,
    pattern: str,
):

    match = re.search(
        pattern,
        text,
    )

    return (
        int(match.group(1))
        if match
        else None
    )


if __name__ == "__main__":
    main()
