from __future__ import annotations

import shutil
from pathlib import Path

from toolkit_common import (
    SCHEMA_VERSION,
    GAME,
    SOURCE,
    git_commit,
    load_json,
    repository,
    sha256,
    write_json,
)

OUT = Path(
    "inspection-output"
)

REPO_OUT = OUT / "repository"

FILES = [
    "README.md",
    "docs/AI-HANDOFF.md",
    ".github/workflows/prepare.yml",
    ".github/workflows/inspect.yml",
    ".github/workflows/merge.yml",
    "scripts/toolkit_common.py",
    "scripts/prepare.py",
    "scripts/inspect_mods.py",
    "scripts/build_diagnostic_bundle.py",
    "scripts/merge_mods.py",
    "scripts/check_candidate.py",
    "scripts/patch_report.py",
]


def main() -> int:

    OUT.mkdir(
        parents=True,
        exist_ok=True,
    )

    inspection = load_json(
        OUT / "InspectionData.json"
    )

    commit = git_commit()

    if (
        inspection.get(
            "checked_commit"
        )
        != commit
    ):

        raise SystemExit(
            "InspectionData.json commit does not "
            "match the current checkout."
        )

    if (
        not SOURCE.is_file()
        or not GAME.is_file()
    ):

        raise SystemExit(
            "Mods.zip and CourseOfTemptation.html "
            "are required for a complete diagnostic bundle."
        )

    shutil.copy2(
        SOURCE,
        OUT / SOURCE.name,
    )

    shutil.copy2(
        GAME,
        OUT / GAME.name,
    )

    shutil.copy2(
        Path("docs/AI-HANDOFF.md"),
        OUT / "AI-HANDOFF.md",
    )

    for relative in FILES:

        source = Path(
            relative
        )

        if not source.is_file():

            raise SystemExit(
                f"Required bundle source is missing: {relative}"
            )

        destination = (
            REPO_OUT / relative
        )

        destination.parent.mkdir(
            parents=True,
            exist_ok=True,
        )

        shutil.copy2(
            source,
            destination,
        )

    files = []

    for path in sorted(
        p
        for p in OUT.rglob("*")
        if (
            p.is_file()
            and p.name != "BundleManifest.json"
        )
    ):

        files.append(
            {
                "path": path.relative_to(
                    OUT
                ).as_posix(),
                "sha256": sha256(path),
                "size": path.stat().st_size,
            }
        )

    manifest = {
        "schema_version": SCHEMA_VERSION,
        "bundle_type": "complete-ai-diagnostic",
        "repository": repository(),
        "checked_commit": commit,
        "input_hashes": {
            "Mods.zip": sha256(SOURCE),
            "CourseOfTemptation.html": sha256(GAME),
        },
        "inspection_status": inspection.get(
            "status"
        ),
        "inspection_hashes": {
            "Mods.zip": inspection.get(
                "source",
                {},
            ).get("sha256"),
            "CourseOfTemptation.html": inspection.get(
                "game",
                {},
            ).get("sha256"),
        },
        "files": files,
        "notes": [
            "Original inputs are preserved as separate files "
            "and are not generated candidates.",
            "Repository sources are copied from the same checkout "
            "used for inspection.",
            "The patcher package itself is not embedded; the build "
            "workflow records its exact release tag and asset hash "
            "when selected.",
        ],
    }

    if (
        manifest["input_hashes"]
        != manifest["inspection_hashes"]
    ):

        raise SystemExit(
            "Input hashes do not match the inspection. "
            "Refusing to create a misleading bundle."
        )

    write_json(
        OUT / "BundleManifest.json",
        manifest,
    )

    return 0


if __name__ == "__main__":
    main()
