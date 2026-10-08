import collections
import hashlib
import html
import json
import os
import re
import subprocess
import sys
import zipfile
from datetime import datetime, timezone
from pathlib import Path, PurePosixPath

ARCHIVE_PATH = Path("Mods.zip")
GAME_PATH = Path("CourseOfTemptation.html")

OUTPUT_DIR = Path("inspection-output")
REPORT_PATH = OUTPUT_DIR / "CompatibilityReport.md"
DATA_PATH = OUTPUT_DIR / "InspectionData.json"
RECEIPT_PATH = OUTPUT_DIR / "InspectionReceipt.json"

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Remove previous reports so an unsuccessful local rerun cannot
# leave an old receipt appearing to describe new inputs.
for path in (REPORT_PATH, DATA_PATH, RECEIPT_PATH):
    if path.exists():
        path.unlink()

blockers = []
warnings = []
entries = []
mod_names = []
extra_formats = []
shared_targets = []
missing_targets = []
multiple_targets = []
baseline_checks = []

game = ""
game_hash = None
archive_hash = None
versions = []

try:
    checked_commit = subprocess.check_output(
        ["git", "rev-parse", "HEAD"],
        text=True,
    ).strip()
except Exception:
    checked_commit = "unknown"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def preview(text, limit=160):
    text = re.sub(r"\s+", " ", text)
    return text[:limit] + ("..." if len(text) > limit else "")


def display(text):
    return text.replace("`", "'").replace("|", r"\|")


def atomic_json(path, value):
    temporary = path.with_name(path.name + ".tmp")
    try:
        temporary.write_text(
            json.dumps(value, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def file_record(path, known_hash=None):
    if not path.is_file():
        return {
            "filename": path.name,
            "sha256": None,
            "bytes": None,
        }

    return {
        "filename": path.name,
        "sha256": known_hash if known_hash is not None else digest(path),
        "bytes": path.stat().st_size,
    }


if not GAME_PATH.is_file():
    blockers.append(
        "Original game HTML missing: CourseOfTemptation.html"
    )
else:
    try:
        game_hash = digest(GAME_PATH)
        game = GAME_PATH.read_text(encoding="utf-8-sig")
    except UnicodeError as exc:
        blockers.append(f"Original HTML is not valid UTF-8: {exc}")
    except OSError as exc:
        blockers.append(f"Cannot read original game HTML: {exc}")

if game:
    decoded_game = html.unescape(game)

    versions = sorted(set(re.findall(
        r'Config\.saves\.version\s*(?:=|to)\s*'
        r'["\'](v[^"\'\s<>]+)["\']',
        decoded_game,
    )))

    if not versions:
        blockers.append(
            "Could not identify Config.saves.version in the original HTML."
        )
    elif len(versions) != 1:
        blockers.append(
            f"Multiple game-version values found: {versions}"
        )
    elif versions != ["v0.8.4d"]:
        warnings.append(
            f"Game version is {versions[0]}. The previous five-group "
            "merge rules were prepared for v0.8.4d and must be reviewed."
        )

if not ARCHIVE_PATH.is_file():
    blockers.append(
        "Original archive missing: Mods.zip. Complete preparation first."
    )
else:
    try:
        archive_hash = digest(ARCHIVE_PATH)

        with zipfile.ZipFile(ARCHIVE_PATH) as archive:
            bad_file = archive.testzip()

            if bad_file is not None:
                blockers.append(
                    f"ZIP integrity check failed at: {bad_file}"
                )

            seen = set()

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
                    blockers.append(f"Unsafe archive path: {name}")
                    continue

                if (
                    "__MACOSX" in path.parts
                    or path.name.startswith("._")
                ):
                    continue

                key = name.casefold()

                if key in seen:
                    blockers.append(
                        f"Duplicate case-insensitive archive path: {name}"
                    )
                    continue

                seen.add(key)

                if not name.lower().endswith(".mod"):
                    continue

                mod_names.append(name)
                raw = archive.read(info)

                try:
                    text = raw.decode("utf-8-sig")
                except UnicodeError as exc:
                    blockers.append(
                        f"Invalid UTF-8 in {name}: {exc}"
                    )
                    continue

                text = text.replace("\r\n", "\n")

                if "\r" in text:
                    warnings.append(
                        f"Standalone carriage return in {name}; "
                        "the previous merger rejects this."
                    )

                markers = []

                if "Replace:" in text and "With:" in text:
                    markers.append("Replace:/With:")

                if re.search(r"^Add Passage:", text, re.M):
                    markers.append("Add Passage:")

                if "<e>" in text:
                    markers.append("<e>")

                if markers:
                    extra_formats.append({
                        "file": name,
                        "markers": markers,
                    })

                parsed_count = 0

                for segment_index, segment in enumerate(text.split("~~")):
                    if "~" not in segment:
                        continue

                    old, new = segment.split("~", 1)
                    old = old.strip()
                    new = new.strip()
                    parsed_count += 1

                    entry = {
                        "file": name,
                        "segment_index": segment_index,
                        "target": old,
                        "replacement": new,
                        "original_match_count": None,
                        "finding": None,
                    }

                    entries.append(entry)

                    if not old:
                        blockers.append(
                            f"Empty search target in {name}, "
                            f"segment {segment_index}."
                        )

                if parsed_count == 0:
                    warnings.append(
                        f"No ~~ / ~ replacements parsed from {name}. "
                        "Its format needs separate review."
                    )

    except Exception as exc:
        blockers.append(f"Could not inspect Mods.zip: {exc}")

if not mod_names and ARCHIVE_PATH.is_file():
    blockers.append("No .mod files found in Mods.zip.")

if mod_names and len(mod_names) != 52:
    warnings.append(
        f"Found {len(mod_names)} mod files. The previous merger expected "
        "52. Review the new archive rather than changing the count blindly."
    )

normalized_game = re.sub(r"\s+", "", game)
owners = collections.defaultdict(set)

for entry in entries:
    target = entry["target"]
    owners[target].add(entry["file"])

    if not target:
        entry["finding"] = "Empty search target"
        continue

    if not game:
        entry["finding"] = "Original HTML unavailable"
        continue

    count = game.count(target)
    entry["original_match_count"] = count

    if count == 0:
        normalized_target = re.sub(r"\s+", "", target)

        detail = (
            "Possible whitespace-only difference"
            if normalized_target and normalized_target in normalized_game
            else "No exact match in original HTML"
        )

        entry["finding"] = detail
        missing_targets.append(entry)

    elif count > 1:
        entry["finding"] = "Multiple exact original matches"
        multiple_targets.append(entry)

    else:
        entry["finding"] = "One exact original match"

for target, files in owners.items():
    if len(files) > 1:
        shared_targets.append({
            "target": target,
            "files": sorted(files),
        })

if missing_targets:
    warnings.append(
        f"{len(missing_targets)} parsed entries have no exact original "
        "HTML match. Some may depend on another replacement."
    )

if multiple_targets:
    warnings.append(
        f"{len(multiple_targets)} parsed entries match multiple original "
        "locations. Review their intended scope."
    )

if shared_targets:
    warnings.append(
        f"{len(shared_targets)} search targets are shared across files. "
        "They require review for overwrite or merge behavior."
    )

if extra_formats:
    warnings.append(
        f"Additional format markers found in {len(extra_formats)} files. "
        "The ~~ / ~ inspection does not interpret those formats."
    )

trio = [
    "KittyBuyOtherResidences.mod",
    "KittyPetNames.mod",
    "KittyPregnancyMod.mod",
]

startup_old = "&lt;&lt;set $pcage to 18&gt;&gt;"

startup_anchor = (
    "&lt;&lt;set $pcbirthday to setup.random_birthday()&gt;&gt;\n"
    "&lt;&lt;set $pcage to setup.minimum_pc_starting_age()&gt;&gt;"
)

baseline_groups = [
    ("this.tattoos = {};", trio, "this.tattoos = {};"),
    (
        "this.age = State.variables.pcage;",
        trio,
        "this.age = State.variables.pcage;",
    ),
    (
        "//#endregion Clothing Management",
        trio,
        "//#endregion Clothing Management",
    ),
    (
        "return [...new Set(inclins)];\n}",
        ["KittyBuyOtherResidences.mod", "KittyPregnancyMod.mod"],
        "return [...new Set(inclins)];\n}",
    ),
    (
        startup_old,
        [
            "KittyBuyOtherResidences.mod",
            "KittyFollowers.mod",
            "KittyGoOverAnybodysHouse.mod",
            "KittyPetNames.mod",
            "KittyPregnancyMod.mod",
        ],
        startup_anchor,
    ),
]

by_basename = collections.defaultdict(list)

for name in mod_names:
    by_basename[PurePosixPath(name).name.casefold()].append(name)

for target, expected_names, anchor in baseline_groups:
    findings = []
    expected_paths = []

    for name in expected_names:
        matches = by_basename[name.casefold()]

        if len(matches) != 1:
            findings.append(
                f"Expected one {name}; found {len(matches)}."
            )
        else:
            expected_paths.append(matches[0])

    matching_entries = [
        entry for entry in entries
        if entry["target"] == target
    ]

    counts = collections.Counter(
        entry["file"] for entry in matching_entries
    )

    if (
        set(counts) != set(expected_paths)
        or any(value != 1 for value in counts.values())
    ):
        findings.append(
            "Target owners or entry counts differ from the previous rule."
        )

    if game.count(anchor) != 1:
        findings.append(
            f"Previous output anchor has {game.count(anchor)} "
            "exact original HTML matches; expected one."
        )

    for entry in matching_entries:
        replacement = entry["replacement"]

        if not replacement.startswith(target):
            findings.append(
                f"Replacement does not retain the anchor: {entry['file']}"
            )
            continue

        tail = replacement[len(target):].strip()

        if not tail or "~" in tail:
            findings.append(
                f"Empty addition or unexpected separator: {entry['file']}"
            )

    baseline_checks.append({
        "target": target,
        "output_anchor": anchor,
        "expected_mods": expected_names,
        "status": (
            "REVIEW"
            if findings
            else "MATCHES PREVIOUS PREREQUISITES"
        ),
        "findings": findings,
    })

if any(check["findings"] for check in baseline_checks):
    warnings.append(
        "At least one previous merge-rule prerequisite differs from "
        "the current input. Update the merger using the report and source."
    )

# A receipt must not describe inputs that changed during inspection.
for path, initial_hash in (
    (ARCHIVE_PATH, archive_hash),
    (GAME_PATH, game_hash),
):
    if initial_hash is None:
        continue

    try:
        final_hash = digest(path)
    except OSError as exc:
        blockers.append(
            f"Cannot recheck inspected input {path}: {exc}"
        )
        continue

    if final_hash != initial_hash:
        blockers.append(
            f"Inspected input changed during inspection: {path}"
        )

script_path = Path(__file__)
script_hash = digest(script_path)

if blockers:
    status = "BLOCKED"
    next_step = (
        "Resolve blocking findings and rerun inspection. "
        "Do not merge or patch this input yet."
    )

elif warnings:
    status = "REVIEW REQUIRED"
    next_step = (
        "Review this report and InspectionData.json against the original "
        "source. Update the merger where required. Preserve the inspection "
        "run ID and InspectionReceipt.json for the reviewed build."
    )

else:
    status = "STATIC CHECKS PASSED"
    next_step = (
        "Review the inspected input and configured merge rules before "
        "manually running the merger. Preserve the inspection run ID "
        "and InspectionReceipt.json. Gameplay is not verified."
    )

data = {
    "schema_version": 1,
    "status": status,
    "checked_commit": checked_commit,
    "repository": os.environ.get("GITHUB_REPOSITORY", ""),
    "workflow_run_id": os.environ.get("GITHUB_RUN_ID", ""),
    "workflow_run_attempt": os.environ.get("GITHUB_RUN_ATTEMPT", ""),
    "inspection_program_sha256": script_hash,
    "archive_path": str(ARCHIVE_PATH),
    "archive_sha256": archive_hash,
    "game_path": str(GAME_PATH),
    "game_sha256": game_hash,
    "game_versions": versions,
    "mod_files": sorted(mod_names),
    "blockers": blockers,
    "warnings": warnings,
    "shared_targets": shared_targets,
    "additional_formats": extra_formats,
    "previous_merge_prerequisites": baseline_checks,
    "entries": entries,
    "limitations": [
        "Read-only static inspection, not patcher execution.",
        "Exact text matching, not the patcher's matching algorithm.",
        "Only ~~ / ~ replacement entries are parsed.",
        "No replacement-order simulation.",
        "No complete JavaScript or SugarCube syntax validation.",
        "No gameplay testing.",
        "A receipt identifies evidence; it does not prove human review.",
    ],
}

atomic_json(DATA_PATH, data)

report = [
    "# Mod Compatibility Inspection",
    "",
    "## Result and next step",
    "",
    f"- Status: {status}",
    f"- Blocking findings: {len(blockers)}",
    f"- Review warnings: {len(warnings)}",
    f"- Next step: {next_step}",
    "",
    "## Inspected inputs",
    "",
    f"- Checked commit: {checked_commit}",
    f"- Repository: {os.environ.get('GITHUB_REPOSITORY', 'unavailable')}",
    f"- Inspection Run ID: {os.environ.get('GITHUB_RUN_ID', 'unavailable')}",
    f"- Run attempt: {os.environ.get('GITHUB_RUN_ATTEMPT', 'unavailable')}",
    f"- Inspection program SHA256: {script_hash}",
    f"- Original archive: {ARCHIVE_PATH}",
    f"- Original archive SHA256: {archive_hash or 'unavailable'}",
    f"- Original HTML: {GAME_PATH}",
    f"- Original HTML SHA256: {game_hash or 'unavailable'}",
    f"- Game version values: {', '.join(versions) or 'not found'}",
    f"- Mod files found: {len(mod_names)}",
    f"- Replacement entries parsed: {len(entries)}",
    "",
    "## Blocking findings",
    "",
    *(
        [f"- {display(item)}" for item in blockers]
        or ["- None detected."]
    ),
    "",
    "## Review warnings",
    "",
    *(
        [f"- {display(item)}" for item in warnings]
        or ["- None detected."]
    ),
    "",
    "## Previous merge-rule prerequisites",
    "",
    "These checks compare against the previous five-group merger.",
    "They do not establish that those rules cover the new archive.",
    "",
]

for check in baseline_checks:
    report.append(
        f"- {check['status']}: "
        f"`{display(preview(check['target']))}`"
    )

    for finding in check["findings"]:
        report.append(f"  - {display(finding)}")

report.extend(["", "## Shared targets across mod files", ""])

if shared_targets:
    for item in shared_targets:
        report.append(
            f"- `{display(preview(item['target']))}` — "
            + ", ".join(display(name) for name in item["files"])
        )
else:
    report.append("- None detected in parsed entries.")

report.extend(["", "## Targets without exact original matches", ""])

if missing_targets:
    for entry in missing_targets:
        report.append(
            f"- {display(entry['file'])}: "
            f"`{display(preview(entry['target']))}` — "
            f"{entry['finding']}"
        )
else:
    report.append("- None detected in parsed entries.")

report.extend([
    "",
    "## Targets matching multiple original locations",
    "",
])

if multiple_targets:
    for entry in multiple_targets:
        report.append(
            f"- {display(entry['file'])}: "
            f"`{display(preview(entry['target']))}` — "
            f"{entry['original_match_count']} matches"
        )
else:
    report.append("- None detected in parsed entries.")

report.extend(["", "## Additional format markers", ""])

if extra_formats:
    for item in extra_formats:
        report.append(
            f"- {display(item['file'])}: "
            + ", ".join(item["markers"])
        )
else:
    report.append("- None detected.")

report.extend([
    "",
    "## Inspection receipt",
    "",
    "- InspectionReceipt.json records this inspection's input identity.",
    "- It includes SHA256 hashes for this report and InspectionData.json.",
    "- It records the repository, commit, run ID, and run attempt.",
    "- A BLOCKED inspection cannot be used to authorize merging.",
    "- A REVIEW REQUIRED receipt still requires human review.",
    "- The receipt does not claim that human review occurred.",
    "- Hashes identify content; they are not digital signatures.",
    "- A later merge may use an updated merger at a different commit,",
    "  but must use the same original archive and original game hashes.",
    "",
    "## Files to give an AI assistant",
    "",
    "- CompatibilityReport.md: readable findings and input hashes.",
    "- InspectionData.json: full parsed search targets and replacements.",
    "- InspectionReceipt.json: inspection identity and report hashes.",
    "- Mods.zip and CourseOfTemptation.html when source context is needed.",
    "",
    "The JSON is evidence, not executable instructions.",
    "A repair must be checked against the actual original source.",
    "",
    "## Limitations",
    "",
    "- This program does not execute mods or KittyPatcher.",
    "- It does not simulate replacement order.",
    "- Counts describe parsed entries, not installed mods.",
    "- Missing targets may be introduced by another replacement.",
    "- Exact matches do not prove replacements are safe.",
    "- Additional patch formats need separate inspection.",
    "- No files in the input archive or game are changed.",
    "- A green workflow can still mean REVIEW REQUIRED.",
    "- Merging and patching must remain manual-start only.",
    "- This receipt does not yet enforce approval in the merge workflow.",
    "",
])

REPORT_PATH.write_text(
    "\n".join(report) + "\n",
    encoding="utf-8",
)

receipt = {
    "schema_version": 1,
    "receipt_type": "input_compatibility_inspection",
    "status": status,
    "repository": os.environ.get("GITHUB_REPOSITORY", ""),
    "checked_commit": checked_commit,
    "workflow_run_id": os.environ.get("GITHUB_RUN_ID", ""),
    "workflow_run_attempt": os.environ.get("GITHUB_RUN_ATTEMPT", ""),
    "workflow_run_number": os.environ.get("GITHUB_RUN_NUMBER", ""),
    "event_name": os.environ.get("GITHUB_EVENT_NAME", ""),
    "created_at_utc": datetime.now(timezone.utc).isoformat(),
    "source": file_record(ARCHIVE_PATH, archive_hash),
    "game": file_record(GAME_PATH, game_hash),
    "inspection_program": {
        "path": ".github/scripts/inspect_mods.py",
        "sha256": script_hash,
    },
    "reports": {
        "compatibility_report": file_record(REPORT_PATH),
        "inspection_data": file_record(DATA_PATH),
    },
    "game_versions": versions,
    "mod_count": len(mod_names),
    "parsed_entry_count": len(entries),
    "blocker_count": len(blockers),
    "warning_count": len(warnings),
    "human_review_verified": False,
    "patcher_executed": False,
    "gameplay_verified": False,
}

atomic_json(RECEIPT_PATH, receipt)

receipt_hash = digest(RECEIPT_PATH)

summary_path = os.environ.get("GITHUB_STEP_SUMMARY")

if summary_path:
    summary = "\n".join([
        "# Input Compatibility Inspection",
        "",
        f"- Status: {status}",
        f"- Blocking findings: {len(blockers)}",
        f"- Review warnings: {len(warnings)}",
        f"- Mod files found: {len(mod_names)}",
        f"- Parsed replacements: {len(entries)}",
        f"- Checked commit: `{checked_commit}`",
        f"- Inspection Run ID: {os.environ.get('GITHUB_RUN_ID', 'unavailable')}",
        f"- Run attempt: {os.environ.get('GITHUB_RUN_ATTEMPT', 'unavailable')}",
        f"- Inspection receipt SHA256: `{receipt_hash}`",
        f"- Next step: {next_step}",
        "",
        "Download the Input-Compatibility-Report artifact for full findings.",
        "It includes InspectionReceipt.json.",
        "",
    ])

    with open(summary_path, "a", encoding="utf-8") as output:
        output.write(summary)

print(
    f"Inspection: {status}; "
    f"{len(blockers)} blockers; "
    f"{len(warnings)} warnings; "
    f"receipt SHA256 {receipt_hash}."
)

sys.exit(1 if blockers else 0)
