"""Latest-release patcher selection: resolve once, verify, pick the EXE.

Includes an end-to-end test against a local fake GitHub API showing that
publishing a newer valid KittyPatcher release changes the selected patcher
with no source or workflow edits, and that a release published mid-build
does not change that build's selection.
"""
import hashlib
import http.server
import io
import json
import os
import subprocess
import sys
import threading
import zipfile
from pathlib import Path

import pytest

from conftest import ROOT

sys.path.insert(0, str(ROOT / ".github/scripts"))
import select_patcher as sp  # noqa: E402

SCRIPT = ROOT / ".github/scripts/select_patcher.py"
BASELINES = ROOT / ".github/patcher-baselines.json"


def zbytes(files):
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as z:
        for n, d in files.items():
            z.writestr(n, d)
    return buf.getvalue()


def sha(b):
    return hashlib.sha256(b).hexdigest()


def release(rid, tag, assets):
    return {"id": rid, "tag_name": tag, "name": tag, "draft": False, "prerelease": False,
            "published_at": "2026-10-08T00:00:00Z", "target_commitish": "main",
            "assets": assets}


def asset(aid, name, data, digest=True):
    a = {"id": aid, "name": name, "size": len(data), "updated_at": "2026-10-08T00:00:00Z"}
    if digest:
        a["digest"] = "sha256:" + sha(data)
    return a


# ---------------- pure selection ----------------

def test_selects_single_matching_asset():
    s = sp.select_asset(release(1, "kitty-patcher", [
        asset(10, "notes.txt", b"x"), asset(11, "KittyPatcher.v0.1.2.zip", b"zip")]))
    assert (s["asset_id"], s["tag_name"], s["published_sha256"]) == (11, "kitty-patcher", sha(b"zip"))


@pytest.mark.parametrize("assets,msg", [
    ([], "no asset"),
    ([asset(1, "other.zip", b"a")], "no asset"),
    ([asset(1, "KittyPatcher-a.zip", b"a"), asset(2, "kittypatcher-b.ZIP", b"b")], "ambiguous"),
])
def test_missing_or_ambiguous_asset_fails(assets, msg):
    with pytest.raises(sp.SelectionError, match=msg):
        sp.select_asset(release(1, "t", assets))


def test_draft_or_prerelease_refused():
    r = release(1, "t", [asset(1, "KittyPatcher.zip", b"a")])
    r["prerelease"] = True
    with pytest.raises(sp.SelectionError, match="prerelease"):
        sp.select_asset(r)


def test_digest_mismatch_fails():
    s = sp.select_asset(release(1, "t", [asset(1, "KittyPatcher.zip", b"good")]))
    with pytest.raises(sp.SelectionError, match="mismatch"):
        sp.verify_digest(s, sha(b"evil"))
    assert sp.verify_digest(s, sha(b"good")) == "verified-against-published-digest"


def test_missing_digest_requires_explicit_matching_approval():
    s = sp.select_asset(release(1, "t", [asset(1, "KittyPatcher.zip", b"d", digest=False)]))
    assert s["published_sha256"] is None
    with pytest.raises(sp.SelectionError, match="explicit approval"):
        sp.verify_digest(s, sha(b"d"))
    with pytest.raises(sp.SelectionError, match="does not match"):
        sp.verify_digest(s, sha(b"d"), "0" * 64)
    assert sp.verify_digest(s, sha(b"d"), sha(b"d")) == "owner-approved-without-published-digest"


def test_exe_identical_copies_collapse_to_shallowest(tmp_path):
    p = tmp_path / "k.zip"
    p.write_bytes(zbytes({"scripts/KittyPatcher v0.1.2.exe": b"E", "KittyPatcher v0.1.2.exe": b"E",
                          "KittyUnescaper v0.1.2.exe": b"U"}))
    r = sp.select_executable(p)
    assert r["exe_member"] == "KittyPatcher v0.1.2.exe" and r["exe_sha256"] == sha(b"E")
    assert len(r["identical_copies"]) == 2


def test_exe_new_layout_single_copy(tmp_path):
    p = tmp_path / "k.zip"
    p.write_bytes(zbytes({"bin/kittypatcher-2.0.EXE": b"N", "README.md": b"r"}))
    assert sp.select_executable(p)["exe_member"] == "bin/kittypatcher-2.0.EXE"


@pytest.mark.parametrize("files,msg", [
    ({"README.md": b"r"}, "No executable"),
    ({"KittyPatcher a.exe": b"1", "x/KittyPatcher b.exe": b"2"}, "ambiguous"),
    ({"../KittyPatcher.exe": b"1"}, "Unsafe path"),
])
def test_exe_selection_failures(tmp_path, files, msg):
    p = tmp_path / "k.zip"
    p.write_bytes(zbytes(files))
    with pytest.raises(sp.SelectionError, match=msg):
        sp.select_executable(p)


def test_v012_baseline_is_history_not_pin():
    b = json.loads(BASELINES.read_text())
    assert b["patchers"][0]["zip_sha256"].startswith("b105af5a")
    assert "Not a pin" in b["note"]


# ---------------- end to end against a fake GitHub API ----------------

class FakeGitHub:
    def __init__(self):
        self.latest = None
        self.assets = {}
        self.latest_calls = 0
        outer = self

        class H(http.server.BaseHTTPRequestHandler):
            def log_message(self, *a):
                pass

            def do_GET(self):
                if self.path == "/repos/o/r/releases/latest":
                    outer.latest_calls += 1
                    body, ctype = json.dumps(outer.latest).encode(), "application/json"
                elif self.path.startswith("/repos/o/r/releases/assets/"):
                    body = outer.assets[int(self.path.rsplit("/", 1)[1])]
                    ctype = "application/octet-stream"
                else:
                    self.send_error(404); return
                self.send_response(200)
                self.send_header("Content-Type", ctype)
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)

        self.srv = http.server.HTTPServer(("127.0.0.1", 0), H)
        threading.Thread(target=self.srv.serve_forever, daemon=True).start()
        self.url = f"http://127.0.0.1:{self.srv.server_port}"

    def publish(self, rid, tag, aid, name, data, digest=True):
        self.assets[aid] = data
        self.latest = release(rid, tag, [asset(aid, name, data, digest)])


@pytest.fixture
def gh():
    f = FakeGitHub()
    yield f
    f.srv.shutdown()


def run(args, cwd, gh):
    env = dict(os.environ, GITHUB_API_URL=gh.url, GH_TOKEN="test")
    env.pop("GITHUB_ENV", None)
    return subprocess.run([sys.executable, str(SCRIPT), *args], cwd=cwd, env=env,
                          capture_output=True, text=True)


def build(tmp, gh, approve=""):
    out = tmp / "work/_patcher"
    r1 = run(["resolve", "--repo", "o/r", "--out", str(out)], tmp, gh)
    assert r1.returncode == 0, r1.stdout + r1.stderr
    return out


def finish(out, tmp, gh, approve=""):
    sel = str(out / "selection.json")
    r2 = run(["download", "--selection", sel], tmp, gh)
    assert r2.returncode == 0, r2.stdout + r2.stderr
    r3 = run(["verify", "--selection", sel, "--approve-sha256", approve,
              "--baselines", str(BASELINES)], tmp, gh)
    return r3, json.loads((out / "selection.json").read_text())


def snapshot():
    files = [ROOT / ".github/workflows/merge.yml", SCRIPT, ROOT / ".github/scripts/patcher_canary.py"]
    return {str(p): sha(p.read_bytes()) for p in files}


def test_newer_release_changes_selection_without_edits(tmp_path, gh):
    before = snapshot()
    old = zbytes({"KittyPatcher v0.1.2.exe": b"OLD", "scripts/KittyPatcher v0.1.2.exe": b"OLD"})
    gh.publish(100, "kitty-patcher", 1000, "KittyPatcher.v0.1.2.zip", old)
    (tmp_path / "a").mkdir()
    r, s1 = finish(build(tmp_path / "a", gh), tmp_path / "a", gh)
    assert r.returncode == 0, r.stdout
    assert (s1["tag_name"], s1["exe_sha256"]) == ("kitty-patcher", sha(b"OLD"))

    new = zbytes({"KittyPatcher-0.2.0/bin/KittyPatcher.exe": b"NEW"})
    gh.publish(200, "kitty-patcher-0.2.0", 2000, "KittyPatcher-0.2.0-win64.zip", new)
    (tmp_path / "b").mkdir()
    r, s2 = finish(build(tmp_path / "b", gh), tmp_path / "b", gh)
    assert r.returncode == 0, r.stdout
    assert s2["release_id"] == 200 and s2["asset_name"] == "KittyPatcher-0.2.0-win64.zip"
    assert s2["exe_member"] == "KittyPatcher-0.2.0/bin/KittyPatcher.exe"
    assert s2["exe_sha256"] == sha(b"NEW")
    assert s2["zip_verification"] == "verified-against-published-digest"
    assert snapshot() == before  # no source or workflow edits were needed


def test_release_published_mid_build_does_not_change_selection(tmp_path, gh):
    gh.publish(100, "v1", 1000, "KittyPatcher-1.zip", zbytes({"KittyPatcher.exe": b"ONE"}))
    out = build(tmp_path, gh)
    gh.publish(200, "v2", 2000, "KittyPatcher-2.zip", zbytes({"KittyPatcher.exe": b"TWO"}))
    r, s = finish(out, tmp_path, gh)
    assert r.returncode == 0, r.stdout
    assert (s["release_id"], s["exe_sha256"]) == (100, sha(b"ONE"))
    assert gh.latest_calls == 1


def test_missing_digest_stops_then_approval_proceeds(tmp_path, gh):
    data = zbytes({"KittyPatcher.exe": b"X"})
    gh.publish(1, "t", 5, "KittyPatcher.zip", data, digest=False)
    out = build(tmp_path, gh)
    r, _ = finish(out, tmp_path, gh)
    assert r.returncode == 1 and "explicit approval" in r.stdout
    r, s = finish(out, tmp_path, gh, approve=sha(data))
    assert r.returncode == 0 and s["zip_verification"] == "owner-approved-without-published-digest"


def test_known_baseline_is_labeled(tmp_path, gh, monkeypatch):
    b = json.loads(BASELINES.read_text())
    data = zbytes({"KittyPatcher.exe": b"Q"})
    b["patchers"].append({"label": "fixture", "zip_sha256": sha(data), "exe_sha256": sha(b"Q")})
    alt = tmp_path / "baselines.json"
    alt.write_text(json.dumps(b))
    gh.publish(1, "t", 5, "KittyPatcher.zip", data)
    out = build(tmp_path, gh)
    run(["download", "--selection", str(out / "selection.json")], tmp_path, gh)
    r = run(["verify", "--selection", str(out / "selection.json"), "--baselines", str(alt)], tmp_path, gh)
    assert r.returncode == 0
    assert json.loads((out / "selection.json").read_text())["matches_historical_baseline"] == ["fixture"]
