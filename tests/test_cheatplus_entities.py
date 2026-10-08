import importlib.util
import subprocess
import sys
import zipfile
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "entity_probe", ROOT / ".github/scripts/probe_cheatplus_entities.py"
)
PROBE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(PROBE)


@pytest.mark.parametrize("name", PROBE.CASES)
def test_probe_detects_missing_replacement(tmp_path, name):
    folder, original_hash = PROBE.prepare(tmp_path, name)
    result = PROBE.evaluate(folder, original_hash)
    assert not result["replacement_marker_present"]
    assert result["untouched_marker_preserved"]
    assert result["mod_unchanged"]


@pytest.mark.parametrize("name", PROBE.CASES)
def test_probe_accepts_marker_and_records_double_escaping(tmp_path, name):
    folder, original_hash = PROBE.prepare(tmp_path, name)
    game = folder / "CourseOfTemptation.html"
    game.write_bytes(game.read_bytes().replace(PROBE.TARGET.encode(), PROBE.RESULT.encode()))
    logs = folder / "mods/logs"
    logs.mkdir()
    (logs / "FailsPatchLog.txt").write_text("&amp;quot;", encoding="utf-8")
    result = PROBE.evaluate(folder, original_hash)
    assert result["replacement_marker_present"]
    assert result["double_escaped_quote_in_logs"]
    assert result["mod_unchanged"]


def test_cases_isolate_raw_macro_in_same_replacement_block():
    assert "<<set _probe to 1>>" not in PROBE.CASES["escaped_only"]
    assert "<<set _probe to 1>>" in PROBE.CASES["raw_macro_same_block"]
    assert all(PROBE.TARGET in content for content in PROBE.CASES.values())


def test_merger_preserves_original_cheatplus_bytes(tmp_path):
    for name in ("Mods.zip", "CourseOfTemptation.html"):
        (tmp_path / name).symlink_to(ROOT / name)
    subprocess.run(
        ["git", "init", "-q", str(tmp_path)], check=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    )
    subprocess.run(
        ["git", "-c", "user.name=Regression Test", "-c", "user.email=test@example.invalid",
         "commit", "--allow-empty", "-qm", "Test fixture"], cwd=tmp_path, check=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    )
    subprocess.run(
        [sys.executable, str(ROOT / ".github/scripts/merge_mods.py")],
        cwd=tmp_path, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    )
    with zipfile.ZipFile(ROOT / "Mods.zip") as original, zipfile.ZipFile(
        tmp_path / "merge-output/Merged_Mods.zip"
    ) as candidate:
        matches = [n for n in original.namelist()
                   if Path(n).name == "m-mod-cheatplus-v0.1.802.mod"]
        assert len(matches) == 1
        name = matches[0]
        assert candidate.read(name) == original.read(name)
