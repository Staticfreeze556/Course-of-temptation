"""Canary evaluation logic (the executable itself runs only on Windows CI)."""
import sys

from conftest import ROOT

sys.path.insert(0, str(ROOT / ".github/scripts"))
import patcher_canary as pc  # noqa: E402


def intended_output():
    out = pc.GAME
    for name, text in pc.MODS.items():
        if "Replace:" in text:
            for seg in text.split("Replace:")[1:]:
                old, new = seg.split("With:", 1)
                out = out.replace(old.strip(), new.strip())
        else:
            for seg in text.split("~~"):
                old, new = seg.split("~", 1)
                out = out.replace(old.strip(), new.strip())
    return out


def prepared(tmp_path):
    pc.prepare(tmp_path)
    return tmp_path / "mods"


def test_intended_literal_patcher_has_no_findings(tmp_path):
    req, prof, findings = pc.evaluate(intended_output(), prepared(tmp_path))
    assert all(req.values()) and findings == []


def test_backslash_rewriting_is_a_finding(tmp_path):
    out = intended_output().replace("CANARY_BACKSLASH_E_DONE \\n \\1 \\\\ end", "CANARY_BACKSLASH_E_DONE \n X \\ end")
    _, _, findings = pc.evaluate(out, prepared(tmp_path))
    assert findings == ["backslashes in replacement kept literally (intended: yes)"]


def test_entity_escaping_is_a_finding(tmp_path):
    out = intended_output().replace("CANARY_ENTITY_D_DONE", "CANARY_ENTITY_D")
    _, _, findings = pc.evaluate(out, prepared(tmp_path))
    assert "entity target in file with raw <<macro>> applied (intended: yes)" in findings


def test_missing_required_replacement_fails(tmp_path):
    out = intended_output().replace("CANARY_KITTY_A_DONE", "CANARY_KITTY_A")
    req, _, _ = pc.evaluate(out, prepared(tmp_path))
    assert req["kitty exact replacement applied"] is False


def test_check_blocks_on_findings_unless_accepted(tmp_path):
    prepared(tmp_path)
    (tmp_path / "CourseOfTemptation.html").write_text(
        intended_output().replace("CANARY_ENTITY_D_DONE", "CANARY_ENTITY_D"))
    assert pc.check(tmp_path, tmp_path / "r.json", accept=False) == 1
    assert pc.check(tmp_path, tmp_path / "r2.json", accept=True) == 0
    import json
    assert json.loads((tmp_path / "r2.json").read_text())["build_label"].startswith("diagnostic")
