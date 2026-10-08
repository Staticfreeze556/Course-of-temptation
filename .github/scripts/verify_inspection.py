import hashlib
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

INSPECTION_DIR = Path("work/_inspection")

RECEIPT_PATH = INSPECTION_DIR / "InspectionReceipt.json"
DATA_PATH = INSPECTION_DIR / "InspectionData.json"
REPORT_PATH = INSPECTION_DIR / "CompatibilityReport.md"

SOURCE_PATH = Path("Mods.zip")
GAME_PATH = Path("CourseOfTemptation.html")

OUTPUT_DIR = Path("merge-output")
REVIEW_PATH = OUTPUT_DIR / "InspectionReview.json"
VALIDATION_REPORT_PATH = OUTPUT_DIR / "InspectionReviewReport.md"

SHA256_PATTERN = r"[0-9a-f]{64}"
COMMIT_PATTERN = r"[0-9a-f]{40}"
POSITIVE_INTEGER_PATTERN = r"[1-9][0-9]*"

MAX_RECEIPT_BYTES = 1024 * 1024
MAX_DATA_BYTES = 64 * 1024 * 1024
MAX_REPORT_BYTES = 32 * 1024 * 1024

ALLOWED_STATUSES = {
    "REVIEW REQUIRED",
    "STATIC CHECKS PASSED",
}

blockers = []
details = []


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require_environment(name):
    value = os.environ.get(name, "").strip()

    if not value:
        raise ValueError(f"Required environment variable is missing: {name}")

    return value


def require_positive_integer(value, label):
    if not re.fullmatch(POSITIVE_INTEGER_PATTERN, value):
        raise ValueError(f"{label} must be a positive integer.")

    return value


def require_sha256(value, label):
    if not isinstance(value, str):
        raise ValueError(f"{label} must be a string.")

    normalized = value.lower()

    if not re.fullmatch(SHA256_PATTERN, normalized):
        raise ValueError(f"{label} must contain a full SHA256 hash.")

    return normalized


def require_nonnegative_count(value, label):
    if type(value) is not int or value < 0:
        raise ValueError(f"{label} must be a nonnegative integer.")

    return value


def read_json_object(path, maximum_bytes):
    if not path.is_file():
        raise ValueError(f"Required inspection file is missing: {path}")

    if path.stat().st_size > maximum_bytes:
        raise ValueError(f"Inspection file exceeds its size limit: {path}")

    value = json.loads(path.read_text(encoding="utf-8"))

    if not isinstance(value, dict):
        raise ValueError(f"Inspection file must contain a JSON object: {path}")

    return value


def verify_file_record(record, path, maximum_bytes=None):
    if not isinstance(record, dict):
        raise ValueError(f"Invalid file record for {path.name}.")

    if record.get("filename") != path.name:
        raise ValueError(f"Unexpected filename in record for {path.name}.")

    expected_hash = require_sha256(
        record.get("sha256"),
        f"{path.name} recorded SHA256",
    )

    expected_bytes = require_nonnegative_count(
        record.get("bytes"),
        f"{path.name} recorded byte count",
    )

    if not path.is_file():
        raise ValueError(f"Required file is missing: {path}")

    actual_bytes = path.stat().st_size

    if maximum_bytes is not None and actual_bytes > maximum_bytes:
        raise ValueError(f"File exceeds its size limit: {path}")

    if actual_bytes != expected_bytes:
        raise ValueError(f"Byte count does not match for {path.name}.")

    actual_hash = sha(path)

    if actual_hash != expected_hash:
        raise ValueError(f"SHA256 does not match for {path.name}.")

    return {
        "filename": path.name,
        "sha256": actual_hash,
        "bytes": actual_bytes,
    }


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


def write_validation_report(status):
    lines = [
        "# Inspection Review Validation",
        "",
        f"- Status: {status}",
        f"- Blocking findings: {len(blockers)}",
        "",
        "## Verified identity",
        "",
        *(details or ["- Validation did not complete."]),
        "",
        "## Blocking findings",
        "",
        *(
            [f"- {item}" for item in blockers]
            or ["- None detected."]
        ),
        "",
        "## Meaning and limitations",
        "",
        "- This validator binds the selected inspection evidence "
        "to the current original inputs.",
        "- The expected receipt hash must be copied from the inspection "
        "the user reviewed.",
        "- Hash verification identifies content; it is not a digital signature.",
        "- Human review is acknowledged, not independently proven.",
        "- Inspection warnings remain subject to human review.",
        "- This validation does not execute or validate merge rules.",
        "- Candidate preflight and patch-output checks remain separate.",
        "- Gameplay remains unverified.",
        "",
    ]

    text = "\n".join(lines) + "\n"

    VALIDATION_REPORT_PATH.write_text(
        text,
        encoding="utf-8",
    )

    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")

    if summary_path:
        with open(summary_path, "a", encoding="utf-8") as output:
            output.write(text)


def verify():
    acknowledged = os.environ.get(
        "INSPECTION_REVIEWED",
        "",
    ).strip().lower()

    if acknowledged != "true":
        raise ValueError(
            "Inspection review acknowledgment is required."
        )

    repository = require_environment("GITHUB_REPOSITORY")

    inspection_run_id = require_positive_integer(
        require_environment("INSPECTION_RUN_ID"),
        "Inspection Run ID",
    )

    inspection_run_attempt = require_positive_integer(
        require_environment("INSPECTION_RUN_ATTEMPT"),
        "Inspection run attempt",
    )

    expected_receipt_hash = require_sha256(
        require_environment("INSPECTION_RECEIPT_SHA256"),
        "Reviewed inspection receipt SHA256",
    )

    receipt = read_json_object(
        RECEIPT_PATH,
        MAX_RECEIPT_BYTES,
    )

    actual_receipt_hash = sha(RECEIPT_PATH)

    if actual_receipt_hash != expected_receipt_hash:
        raise ValueError(
            "Downloaded receipt does not match the receipt hash "
            "selected for review."
        )

    if receipt.get("schema_version") != 1:
        raise ValueError("Unsupported inspection receipt schema.")

    if (
        receipt.get("receipt_type")
        != "input_compatibility_inspection"
    ):
        raise ValueError("Unexpected inspection receipt type.")

    if receipt.get("repository") != repository:
        raise ValueError(
            "Inspection receipt belongs to another repository."
        )

    if str(receipt.get("workflow_run_id")) != inspection_run_id:
        raise ValueError(
            "Inspection receipt belongs to another workflow run."
        )

    if (
        str(receipt.get("workflow_run_attempt"))
        != inspection_run_attempt
    ):
        raise ValueError(
            "Inspection receipt belongs to another run attempt."
        )

    inspected_commit = receipt.get("checked_commit")

    if (
        not isinstance(inspected_commit, str)
        or not re.fullmatch(COMMIT_PATTERN, inspected_commit)
    ):
        raise ValueError(
            "Inspection receipt has an invalid checked commit."
        )

    status = receipt.get("status")

    if status == "BLOCKED":
        raise ValueError(
            "A blocked inspection cannot authorize merging."
        )

    if status not in ALLOWED_STATUSES:
        raise ValueError(
            "Inspection receipt has an unsupported status."
        )

    blocker_count = require_nonnegative_count(
        receipt.get("blocker_count"),
        "Inspection blocker count",
    )

    warning_count = require_nonnegative_count(
        receipt.get("warning_count"),
        "Inspection warning count",
    )

    if blocker_count != 0:
        raise ValueError(
            "Inspection receipt contains blocking findings."
        )

    if status == "STATIC CHECKS PASSED" and warning_count != 0:
        raise ValueError(
            "Inspection status contradicts its warning count."
        )

    if status == "REVIEW REQUIRED" and warning_count == 0:
        raise ValueError(
            "Inspection status contradicts its warning count."
        )

    reports = receipt.get("reports")

    if not isinstance(reports, dict):
        raise ValueError(
            "Inspection receipt reports record must be an object."
        )

    verified_report = verify_file_record(
        reports.get("compatibility_report"),
        REPORT_PATH,
        MAX_REPORT_BYTES,
    )

    verified_data = verify_file_record(
        reports.get("inspection_data"),
        DATA_PATH,
        MAX_DATA_BYTES,
    )

    data = read_json_object(
        DATA_PATH,
        MAX_DATA_BYTES,
    )

    if data.get("schema_version") != 1:
        raise ValueError("Unsupported inspection data schema.")

    expected_identity = {
        "status": status,
        "repository": repository,
        "checked_commit": inspected_commit,
        "workflow_run_id": inspection_run_id,
        "workflow_run_attempt": inspection_run_attempt,
    }

    for key, expected in expected_identity.items():
        actual = data.get(key)

        if key in {"workflow_run_id", "workflow_run_attempt"}:
            actual = str(actual)

        if actual != expected:
            raise ValueError(
                f"Inspection data and receipt disagree on {key}."
            )

    data_blockers = data.get("blockers")
    data_warnings = data.get("warnings")

    if (
        not isinstance(data_blockers, list)
        or not all(isinstance(item, str) for item in data_blockers)
    ):
        raise ValueError(
            "Inspection blockers must be a list of strings."
        )

    if (
        not isinstance(data_warnings, list)
        or not all(isinstance(item, str) for item in data_warnings)
    ):
        raise ValueError(
            "Inspection warnings must be a list of strings."
        )

    if len(data_blockers) != blocker_count:
        raise ValueError(
            "Inspection blocker count does not match its data."
        )

    if data_blockers:
        raise ValueError(
            "Inspection data contains blocking findings."
        )

    if len(data_warnings) != warning_count:
        raise ValueError(
            "Inspection warning count does not match its data."
        )

    source_record = verify_file_record(
        receipt.get("source"),
        SOURCE_PATH,
    )

    game_record = verify_file_record(
        receipt.get("game"),
        GAME_PATH,
    )

    if data.get("archive_path") != "Mods.zip":
        raise ValueError(
            "Inspection data has an unexpected archive path."
        )

    if data.get("game_path") != "CourseOfTemptation.html":
        raise ValueError(
            "Inspection data has an unexpected game path."
        )

    if data.get("archive_sha256") != source_record["sha256"]:
        raise ValueError(
            "Inspection data archive hash disagrees with the receipt."
        )

    if data.get("game_sha256") != game_record["sha256"]:
        raise ValueError(
            "Inspection data HTML hash disagrees with the receipt."
        )

    program = receipt.get("inspection_program")

    if not isinstance(program, dict):
        raise ValueError(
            "Inspection program record must be an object."
        )

    if program.get("path") != ".github/scripts/inspect_mods.py":
        raise ValueError(
            "Unexpected inspection program path."
        )

    inspection_program_hash = require_sha256(
        program.get("sha256"),
        "Inspection program SHA256",
    )

    if (
        data.get("inspection_program_sha256")
        != inspection_program_hash
    ):
        raise ValueError(
            "Inspection program hash disagrees between data and receipt."
        )

    checked_commit = subprocess.check_output(
        ["git", "rev-parse", "HEAD"],
        text=True,
    ).strip()

    if not re.fullmatch(COMMIT_PATTERN, checked_commit):
        raise ValueError("Current checkout commit is invalid.")

    # The merger may have been updated after inspection.
    # Input hashes, rather than commit equality, bind the review.
    review = {
        "schema_version": 1,
        "status": "INSPECTION_INPUTS_VERIFIED",
        "repository": repository,
        "build_workflow_run_id": os.environ.get("GITHUB_RUN_ID", ""),
        "build_workflow_run_attempt": os.environ.get(
            "GITHUB_RUN_ATTEMPT",
            "",
        ),
        "build_checked_commit": checked_commit,
        "inspection_workflow_run_id": inspection_run_id,
        "inspection_workflow_run_attempt": inspection_run_attempt,
        "inspection_checked_commit": inspected_commit,
        "inspection_status": status,
        "inspection_receipt_sha256": actual_receipt_hash,
        "inspection_program_sha256": inspection_program_hash,
        "verified_at_utc": datetime.now(timezone.utc).isoformat(),
        "source": source_record,
        "game": game_record,
        "reports": {
            "compatibility_report": verified_report,
            "inspection_data": verified_data,
        },
        "blocker_count": blocker_count,
        "warning_count": warning_count,
        "human_review_acknowledged": True,
        "human_review_independently_verified": False,
        "workflow_origin_verified_by_this_program": False,
        "merge_rules_verified": False,
        "patcher_executed": False,
        "gameplay_verified": False,
    }

    atomic_json(REVIEW_PATH, review)

    details.extend([
        f"- Repository: {repository}",
        f"- Build commit: `{checked_commit}`",
        f"- Inspected commit: `{inspected_commit}`",
        f"- Inspection Run ID: {inspection_run_id}",
        f"- Inspection run attempt: {inspection_run_attempt}",
        f"- Inspection status: {status}",
        f"- Reviewed receipt SHA256: `{actual_receipt_hash}`",
        f"- Original archive SHA256: `{source_record['sha256']}`",
        f"- Original HTML SHA256: `{game_record['sha256']}`",
        f"- Inspection warnings acknowledged: {warning_count}",
        "- Reviewed original inputs match the current merge inputs.",
    ])

    write_validation_report("INSPECTION INPUTS VERIFIED")

    print(
        f"Inspection {inspection_run_id}, attempt "
        f"{inspection_run_attempt}, matches current original inputs."
    )


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    for path in (REVIEW_PATH, VALIDATION_REPORT_PATH):
        if path.exists():
            path.unlink()

    try:
        verify()
    except Exception as exc:
        if REVIEW_PATH.exists():
            REVIEW_PATH.unlink()

        blockers.append(
            f"{type(exc).__name__}: {exc}"
        )

        write_validation_report("BLOCKED")

        print(
            "Inspection review validation failed. "
            "Read InspectionReviewReport.md.",
            file=sys.stderr,
        )

        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
