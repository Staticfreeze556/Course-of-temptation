"""Golden baseline for the existing inspector (.github/scripts/inspect_mods.py).

Records current behavior; it does not endorse it. If a later phase changes
these numbers, update them in a reviewed commit with the reason.
"""
import collections
import json
import os
import shutil
import subprocess
import sys

import pytest

from conftest import ARCHIVE, GAME, ROOT


@pytest.fixture(scope="module")
def data(tmp_path_factory):
    work = tmp_path_factory.mktemp("inspect")
    for src in (GAME, ARCHIVE):
        os.symlink(src, work / src.name)
    shutil.copytree(ROOT / ".github", work / ".github")
    subprocess.run(
        [sys.executable, ".github/scripts/inspect_mods.py"],
        cwd=work, check=True, capture_output=True, text=True,
    )
    return json.loads((work / "inspection-output/InspectionData.json").read_text())


def test_status(data):
    assert data["status"] == "REVIEW REQUIRED"
    assert data["blockers"] == []
    assert data["game_versions"] == ["v0.8.4d"]


def test_warnings(data):
    w = data["warnings"]
    assert len(w) == 5
    assert any("m-mod-cheatplus" in x and "separate review" in x for x in w)
    assert any("Additional format markers" in x for x in w)


def test_finding_counts(data):
    c = collections.Counter(e["finding"] for e in data["entries"])
    assert len(data["entries"]) == 166
    assert c == {
        "One exact original match": 68,
        "Multiple exact original matches": 5,
        "No exact match in original HTML": 87,
        "Possible whitespace-only difference": 6,
    }
