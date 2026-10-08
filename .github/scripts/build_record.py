"""Write BuildRecord.json: every identity needed to reproduce or audit a build.

Runs with if: always(); missing items are recorded as null, not invented.
"""
import argparse
import hashlib
import json
import os
import subprocess
from pathlib import Path


def h(p):
    p = Path(p)
    if not p.is_file():
        return None
    d = hashlib.sha256()
    with open(p, "rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            d.update(c)
    return {"path": str(p).replace("\\", "/"), "sha256": d.hexdigest(), "bytes": p.stat().st_size}


def load(p):
    try:
        return json.loads(Path(p).read_text(encoding="utf-8"))
    except Exception:
        return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    try:
        commit = subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip()
    except Exception:
        commit = None
    sel = load("work/_patcher/selection.json") or {}
    canary = load("work/PatcherCanary.json") or {}
    mods_dir = Path("work/mods")
    rec = {
        "schema_version": 1,
        "label": "diagnostic baseline - gameplay and save compatibility unverified",
        "build_label": os.environ.get("BUILD_LABEL") or canary.get("build_label"),
        "repository": os.environ.get("GITHUB_REPOSITORY"),
        "run_id": os.environ.get("GITHUB_RUN_ID"),
        "run_attempt": os.environ.get("GITHUB_RUN_ATTEMPT"),
        "commit": commit,
        "patcher": {k: sel.get(k) for k in (
            "release_id", "tag_name", "release_name", "published_at", "asset_id",
            "asset_name", "asset_size", "published_sha256", "zip_sha256",
            "zip_verification", "exe_member", "exe_sha256", "identical_copies",
            "matches_historical_baseline")},
        "canary": {k: canary.get(k) for k in (
            "canary_output_sha256", "required_failed", "findings", "findings_accepted")},
        "inputs": {
            "original_game": h("CourseOfTemptation.html"),
            "original_mods_zip": h("Mods.zip"),
            "candidate_zip": h("work/_candidate/Merged_Mods.zip"),
            "candidate_manifest": h("work/_candidate/MergeManifest.json"),
            "patched_mods": sorted(
                (h(p) for p in mods_dir.glob("*") if p.is_file() and p.suffix.lower() == ".mod"),
                key=lambda x: x["path"]) if mods_dir.is_dir() else [],
        },
        "logs": [h(p) for p in sorted(Path("work/mods/logs").glob("*.txt"))]
        if Path("work/mods/logs").is_dir() else [],
        "working_game_copy": h("work/CourseOfTemptation.html"),
        "patched": bool(canary.get("build_label") in ("normal", "diagnostic: patcher behavior findings accepted")
                        and Path("work/mods/logs/MainPatchLog.txt").is_file()),
        "note": "working_game_copy is the patched output only when patched is true; otherwise it is the unmodified copy.",
    }
    Path(a.out).write_text(json.dumps(rec, indent=2) + "\n", encoding="utf-8")
    print(f"Build record written: {a.out}")


if __name__ == "__main__":
    main()
