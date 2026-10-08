"""Static checks on workflow configuration."""
import re

import yaml

from conftest import PATCHER_EXE_SHA256, PATCHER_ZIP_SHA256, ROOT

WF = ROOT / ".github/workflows"


def load(name):
    return yaml.safe_load((WF / name).read_text())


def test_all_workflows_parse():
    for p in WF.glob("*.yml"):
        assert yaml.safe_load(p.read_text())


def _patch_job_steps():
    jobs = load("merge.yml")["jobs"]
    return [s for j in jobs.values() for s in j.get("steps", [])]


def test_patcher_is_pinned_not_latest():
    text = (WF / "merge.yml").read_text()
    assert "latest repository release" not in text
    assert "gh release view" not in text
    step = next(s for s in _patch_job_steps()
                if s.get("name") == "Download pinned KittyPatcher release")
    assert step["env"]["PATCHER_TAG"] == "kitty-patcher"
    assert step["env"]["PATCHER_ASSET"] == "KittyPatcher.v0.1.2.zip"
    assert step["env"]["PATCHER_ZIP_SHA256"] == PATCHER_ZIP_SHA256
    assert "-ne $env:PATCHER_ZIP_SHA256" in step["run"]
    assert "throw" in step["run"]


def test_patcher_exe_pinned_and_not_recursive():
    step = next(s for s in _patch_job_steps() if s.get("name") == "Run KittyPatcher")
    assert step["env"]["PATCHER_EXE_SHA256"] == PATCHER_EXE_SHA256
    assert "-Recurse" not in step["run"]
    assert "-ne $env:PATCHER_EXE_SHA256" in step["run"]


def test_inspect_bundle_files_exist():
    # inspect.yml fails when any of these are missing (baseline CI failure).
    text = (WF / "inspect.yml").read_text()
    block = text[text.index("paths = ["):text.index("]", text.index("paths = ["))]
    names = re.findall(r'"([^"]+)"', block)
    assert "README.md" in names and "docs/AI-HANDOFF.md" in names
    missing = [n for n in names if not (ROOT / n).is_file()]
    assert missing == []
