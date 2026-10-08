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


def _patch_steps():
    return load("merge.yml")["jobs"]["patch"]["steps"] if "patch" in load("merge.yml")["jobs"] else [
        s for j in load("merge.yml")["jobs"].values() if j.get("runs-on") == "windows-latest"
        for s in j["steps"]]


def _names():
    return [s.get("name") for s in _patch_steps()]


# Requirement (owner, 2026-10-07): builds follow the latest KittyPatcher
# release; v0.1.2 is a historical baseline, not a pin. These tests replace
# the Phase 1 pin tests, which encoded the superseded requirement.

def test_latest_release_resolved_exactly_once():
    text = (WF / "merge.yml").read_text()
    assert text.count("select_patcher.py resolve") == 1
    assert "gh release" not in text and "releases/latest" not in text


def test_no_hard_coded_patcher_identity_in_workflow():
    text = (WF / "merge.yml").read_text()
    for pinned in ("v0.1.2", "kitty-patcher'", PATCHER_ZIP_SHA256, PATCHER_EXE_SHA256,
                   "KittyPatcher.v0.1.2.zip"):
        assert pinned not in text, pinned


def test_step_order_resolve_verify_canary_then_patch():
    n = _names()
    order = ["Resolve latest KittyPatcher release (once per build)",
             "Download selected KittyPatcher asset by ID",
             "Verify digest and select executable",
             "Patcher behavior canary",
             "Run KittyPatcher",
             "Record build identity"]
    assert [n.index(x) for x in order] == sorted(n.index(x) for x in order)
    assert n.index(order[0]) < n.index("Verify manifest and inspect candidate")


def test_later_steps_use_recorded_selection():
    steps = {s.get("name"): s for s in _patch_steps()}
    for name in ("Download selected KittyPatcher asset by ID", "Verify digest and select executable",
                 "Patcher behavior canary", "Run KittyPatcher"):
        assert "work/_patcher/selection.json" in steps[name]["run"], name
    run = steps["Run KittyPatcher"]["run"]
    assert "-Recurse" not in run and "exe_sha256" in run


def test_unverified_digest_needs_explicit_input():
    wf = load("merge.yml")
    inputs = wf[True]["workflow_dispatch"]["inputs"] if True in wf else wf["on"]["workflow_dispatch"]["inputs"]
    assert inputs["approve_unverified_patcher_sha256"]["default"] == ""
    assert inputs["accept_patcher_behavior_findings"]["default"] is False


def test_build_record_uploaded():
    text = (WF / "merge.yml").read_text()
    for f in ("work/BuildRecord.json", "work/PatcherCanary.json", "work/_patcher/selection.json"):
        assert f in text


def test_inspect_bundle_files_exist():
    # inspect.yml fails when any of these are missing (baseline CI failure).
    text = (WF / "inspect.yml").read_text()
    block = text[text.index("paths = ["):text.index("]", text.index("paths = ["))]
    names = re.findall(r'"([^"]+)"', block)
    assert "README.md" in names and "docs/AI-HANDOFF.md" in names
    missing = [n for n in names if not (ROOT / n).is_file()]
    assert missing == []
