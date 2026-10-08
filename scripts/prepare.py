from pathlib import Path
import sys

from toolkit_common import (
    SOURCE,
    sha256,
    validate_archive,
    write_summary,
)

REPORT_DIR = Path("preparation-output")
REPORT = REPORT_DIR / "PreparationReport.md"


def main() -> int:

    REPORT_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )

    archives = sorted(
        p
        for p in Path(".").iterdir()
        if p.is_file()
        and p.suffix.lower() == ".zip"
    )

    incoming = [
        p
        for p in archives
        if p.name != SOURCE.name
    ]

    report = [
        "# Original Mod Archive Preparation",
        "",
        "This stage validates an original mod archive and "
        "normalizes its filename. It never merges mods or "
        "runs KittyPatcher.",
        "",
        "## Input discovery",
        "",
    ]

    if archives:
        report.extend(
            f"- `{p.name}`"
            for p in archives
        )
    else:
        report.append(
            "- No root-level ZIP files found."
        )

    if len(incoming) > 1:

        report += [
            "",
            "## Result",
            "",
            "- Status: **BLOCKED**",
            "- More than one non-canonical ZIP was found. "
            "No file was changed.",
        ]

        REPORT.write_text(
            "\n".join(report) + "\n",
            encoding="utf-8",
        )

        write_summary(
            "# Input preparation\n\n"
            "- **BLOCKED:** multiple incoming ZIP files were found."
        )

        return 1

    source = (
        incoming[0]
        if incoming
        else (
            SOURCE
            if SOURCE.is_file()
            else None
        )
    )

    if source is None:

        report += [
            "",
            "## Result",
            "",
            "- Status: **BLOCKED**",
            "- No original mod ZIP was found.",
        ]

        REPORT.write_text(
            "\n".join(report) + "\n",
            encoding="utf-8",
        )

        return 1

    try:
        records = validate_archive(
            source
        )
    except Exception as exc:

        report += [
            "",
            "## Result",
            "",
            "- Status: **BLOCKED**",
            f"- `{type(exc).__name__}: {exc}`",
            "- The source archive was not renamed or replaced.",
        ]

        REPORT.write_text(
            "\n".join(report) + "\n",
            encoding="utf-8",
        )

        write_summary(
            f"# Input preparation\n\n"
            f"- **BLOCKED:** {exc}"
        )

        return 1

    mods = sorted(
        r["name"]
        for r in records
        if r["name"].lower().endswith(".mod")
    )

    digest = sha256(source)

    operation = "already canonical"

    if source != SOURCE:

        source.replace(SOURCE)

        operation = (
            f"renamed `{source.name}` "
            f"to `{SOURCE.name}`"
        )

    if sha256(SOURCE) != digest:

        report += [
            "",
            "## Result",
            "",
            "- Status: **BLOCKED**",
            "- Post-normalization SHA-256 verification failed.",
        ]

        REPORT.write_text(
            "\n".join(report) + "\n",
            encoding="utf-8",
        )

        return 1

    report += [
        "",
        "## Result",
        "",
        "- Status: **PREPARED**",
        f"- Operation: {operation}",
        f"- SHA-256: `{digest}`",
        f"- `.mod` files: **{len(mods)}**",
        "- ZIP contents were not rewritten.",
        "",
        "## Mod files",
        "",
    ]

    report.extend(
        f"- `{name}`"
        for name in mods
    )

    report += [
        "",
        "## Next stage",
        "",
        "Run compatibility inspection. Preparation does not "
        "establish compatibility.",
    ]

    REPORT.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    write_summary(
        "# Input preparation\n\n"
        f"- **PREPARED**\n"
        f"- Mods: {len(mods)}\n"
        f"- SHA-256: `{digest}`"
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())
