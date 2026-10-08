import hashlib
import os
import sys
import zipfile
from pathlib import Path, PurePosixPath

ROOT = Path(".")
TARGET = ROOT / "Mods.zip"
REPORT_DIR = ROOT / "preparation-output"
REPORT_PATH = REPORT_DIR / "PreparationReport.md"

REPORT_DIR.mkdir(parents=True, exist_ok=True)

report = [
    "# Original Mod Archive Preparation",
    "",
    "## Purpose",
    "",
    "Validate the uploaded original ZIP and normalize its name to Mods.zip.",
    "This step does not merge mods, run KittyPatcher, or verify compatibility.",
    "",
]


def finish(status, message, failed=False):
    report.extend([
        "",
        "## Result",
        "",
        f"- Status: {status}",
        f"- {message}",
        "",
    ])

    REPORT_PATH.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary_path:
        with open(summary_path, "a", encoding="utf-8") as summary:
            summary.write(REPORT_PATH.read_text(encoding="utf-8"))

    print(f"{status}: {message}")
    sys.exit(1 if failed else 0)


archives = sorted(
    path
    for path in ROOT.iterdir()
    if path.is_file() and path.suffix.lower() == ".zip"
)

incoming = [
    path for path in archives
    if path.name != TARGET.name
]

if len(incoming) > 1:
    report.extend([
        "## Uploaded ZIPs",
        "",
        *[f"- {path.name}" for path in incoming],
    ])
    finish(
        "BLOCKED",
        "More than one incoming ZIP was found at the repository root. "
        "Leave only one new original mod archive there. "
        "No archive was renamed or replaced.",
        failed=True,
    )

if incoming:
    source = incoming[0]
elif TARGET.is_file():
    source = TARGET
else:
    finish(
        "BLOCKED",
        "No original mod ZIP was found. Upload one ZIP at the "
        "repository root, then run preparation again.",
        failed=True,
    )

report.extend([
    "## Input",
    "",
    f"- Uploaded filename: {source.name}",
    f"- Required final filename: {TARGET.name}",
    "",
])

if not zipfile.is_zipfile(source):
    finish(
        "BLOCKED",
        f"{source.name} is not a readable ZIP archive. "
        "No archive was renamed or replaced.",
        failed=True,
    )

mod_names = []
seen = set()
problems = []

try:
    with zipfile.ZipFile(source) as archive:
        bad_file = archive.testzip()

        if bad_file is not None:
            problems.append(
                f"ZIP integrity check failed at: {bad_file}"
            )

        for info in archive.infolist():
            if info.is_dir():
                continue

            name = info.filename.replace("\\", "/")
            path = PurePosixPath(name)

            if (
                path.is_absolute()
                or ".." in path.parts
                or (
                    path.parts
                    and ":" in path.parts[0]
                )
            ):
                problems.append(f"Unsafe archive path: {name}")
                continue

            if (
                "__MACOSX" in path.parts
                or path.name.startswith("._")
            ):
                continue

            key = name.casefold()

            if key in seen:
                problems.append(
                    f"Duplicate case-insensitive archive path: {name}"
                )
                continue

            seen.add(key)

            if name.lower().endswith(".mod"):
                mod_names.append(name)

except Exception as exc:
    problems.append(f"Could not inspect ZIP contents: {exc}")

if not mod_names:
    problems.append(
        "No .mod files were found in the archive."
    )

if problems:
    report.extend([
        "## Blocking findings",
        "",
        *[f"- {problem}" for problem in problems],
    ])
    finish(
        "BLOCKED",
        "Archive validation failed. "
        "No archive was renamed or replaced.",
        failed=True,
    )

archive_hash = hashlib.sha256(
    source.read_bytes()
).hexdigest()

replaced_existing = (
    source.name != TARGET.name
    and TARGET.is_file()
)

if source.name != TARGET.name:
    try:
        os.replace(source, TARGET)
    except OSError as exc:
        finish(
            "BLOCKED",
            f"Could not rename the archive to Mods.zip: {exc}",
            failed=True,
        )
    operation = (
        "Replaced the previous Mods.zip with the uploaded archive."
        if replaced_existing
        else "Renamed the uploaded archive to Mods.zip."
    )
else:
    operation = "Archive was already named Mods.zip."

if hashlib.sha256(
    TARGET.read_bytes()
).hexdigest() != archive_hash:
    finish(
        "BLOCKED",
        "Archive content verification failed after normalization.",
        failed=True,
    )

report.extend([
    "## Validation",
    "",
    "- ZIP integrity check passed.",
    "- Archive path checks passed.",
    f"- Mod files found: {len(mod_names)}",
    f"- Original archive SHA256: {archive_hash}",
    "- Archive contents were not rewritten.",
    f"- Operation: {operation}",
    "",
    "## Mod files",
    "",
    *[f"- {name}" for name in sorted(mod_names)],
    "",
    "## Next step",
    "",
    "Run compatibility inspection against Mods.zip and the original "
    "CourseOfTemptation.html.",
    "",
    "Preparation does not establish that the mods support the game version.",
    "The merger and patcher must remain separate manual stages.",
])

finish(
    "PREPARED",
    "The original archive is available as Mods.zip. "
    "Compatibility inspection is the next stage.",
)
