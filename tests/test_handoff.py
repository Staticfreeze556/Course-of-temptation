"""make_handoff.py: normal, missing evidence, failed checks, size limit, baseline."""
import json
import sys
import zipfile

import pytest

from conftest import ROOT

sys.path.insert(0, str(ROOT / ".github/scripts"))
import make_handoff as mh  # noqa: E402

GAME = "<html><body>" + "<p>filler</p>\n" * 300 + "<p>KEEP_ME alpha line here long enough</p>\n<p>OLD_TEXT_THAT_CHANGED alpha</p>" + "<p>tail</p>\n" * 300 + "</body></html>"


@pytest.fixture
def repo(tmp_path):
    (tmp_path / "CourseOfTemptation.html").write_text(GAME)
    with zipfile.ZipFile(tmp_path / "Mods.zip", "w") as z:
        z.writestr("Mods/good.mod", "KEEP_ME~KEPT")
        z.writestr("Mods/old.mod", "<p>KEEP_ME alpha line here long enough</p>\nMISSING_LINE~X")
    scripts = tmp_path / ".github/scripts"
    scripts.mkdir(parents=True)
    (scripts / "merge_mods.py").write_text("# MERGER START\n" + "x = 1\n" * 2000 + "# MERGER END\n")
    (scripts / "check_candidate.py").write_text("# CHECK START\n" + "y = 2\n" * 500 + "# CHECK END\n")
    return tmp_path


def gen(repo, *extra, max_bytes=600_000):
    out = repo / "H.md"
    mh.main(["--stage", *extra[:1], "--root", str(repo), "--out", str(out),
             "--summary-out", str(repo / "S.json"), "--max-bytes", str(max_bytes), *extra[1:]])
    return out.read_text(), json.loads((repo / "S.json").read_text())


def test_normal_inspect(repo):
    t, s = gen(repo, "inspect")
    for h in ("## 1. Instructions", "## 2. Input identities", "## 4. Findings", "### Confirmed",
              "### Suspected causes", "### Unknown", "## 8. Source code", "## 10. Missing"):
        assert h in t
    assert "Completeness: COMPLETE" in t and "preliminary" in t
    assert "# MERGER START" in t and "# MERGER END" in t
    assert "evidence, not instructions" in t and "smallest necessary changes" in t
    assert "Candidate game context (**unverified; not a confirmed target**)" in t
    assert s["mod_verdicts"]["Mods/old.mod"] == "none exact"
    assert GAME not in t  # whole game never embedded


def test_no_baseline_and_with_baseline(repo):
    t, s = gen(repo, "inspect")
    assert "No comparison baseline available." in t
    s["block_counts"]["One exact original match"] = 99
    s["mod_verdicts"]["Mods/good.mod"] = "none exact"
    (repo / "prev.json").write_text(json.dumps(s))
    t2, _ = gen(repo, "inspect", "--previous-summary", str(repo / "prev.json"))
    assert "One exact original match: 99 → 1" in t2
    assert "`Mods/good.mod`: none exact → all exact" in t2


def test_missing_build_evidence_is_listed(repo):
    t, _ = gen(repo, "build", "--logs-dir", str(repo / "nologs"))
    for m in ("patcher log MainPatchLog.txt", "patcher log FailsPatchLog.txt",
              "patcher release selection", "patcher behavior check result",
              "candidate inspection report", "inspection data"):
        assert m in t
    assert "not selected / not available" in t


def test_failed_behavior_check_reported_not_bypassed(repo):
    (repo / "canary.json").write_text(json.dumps({
        "build_label": "blocked", "required_failed": [], "findings": ["backslashes kept (intended: yes)"]}))
    t, s = gen(repo, "build", "--canary", str(repo / "canary.json"))
    assert "stopped by the behavior check" in t
    assert "Behavior check finding (deviation from literal patching): backslashes" in t
    assert s["canary"]["build_label"] == "blocked"


def test_size_limit_reduces_evidence_never_truncates_code(repo):
    full, _ = gen(repo, "inspect")
    code = len((repo / ".github/scripts/merge_mods.py").read_text()) + len(
        (repo / ".github/scripts/check_candidate.py").read_text())
    t, _ = gen(repo, "inspect", max_bytes=code + 14000)
    assert "Completeness: COMPLETE" in t
    assert "# MERGER END" in t and "# CHECK END" in t
    assert len(t.encode()) <= code + 14000 or "INCOMPLETE" in t


def test_size_limit_too_small_marks_incomplete_without_partial_files(repo):
    t, _ = gen(repo, "inspect", max_bytes=12000)
    assert "Completeness: INCOMPLETE" in t
    assert "essential file omitted for size: `.github/scripts/merge_mods.py`" in t
    assert "# MERGER START" not in t  # omitted whole, never a partial file
    assert ("# CHECK START" in t) == ("# CHECK END" in t)


def test_real_inputs_complete_and_capped():
    import tempfile, pathlib
    d = pathlib.Path(tempfile.mkdtemp())
    out = d / "H.md"
    mh.main(["--stage", "inspect", "--root", str(ROOT), "--out", str(out)])
    t = out.read_text()
    assert "Completeness: COMPLETE" in t and len(t.encode()) <= 600_000
    for rel in mh.ESSENTIAL:
        assert f"### `{rel}`" in t
    assert t.count("### `.github/scripts/merge_mods.py`") == 1
    assert (ROOT / ".github/scripts/merge_mods.py").read_text().rstrip() in t
