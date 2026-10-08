"""Merger pre-escape that works around KittyPatcher's entity double-escaping."""
import subprocess
import sys
import zipfile
from pathlib import Path

import pytest

from conftest import ROOT

sys.path.insert(0, str(ROOT / ".github/scripts"))
sys.path.insert(0, str(Path(__file__).parent))
import kitty_escape as ke  # noqa: E402
import kittypatcher_v012_reference as ref  # noqa: E402
import patcher_canary as pc  # noqa: E402

GAME = '<p>&lt;&lt;set _label to &quot;Watch TV&quot;&gt;&gt;</p><p>UNTOUCHED</p>'
TARGET = '&lt;&lt;set _label to &quot;Watch TV&quot;&gt;&gt;'
MIXED = f'Replace:\n{TARGET}\nWith:\n{TARGET} DONE\n<<set _probe to 1>>\n'
ESCAPED_ONLY = f'Replace:\n{TARGET}\nWith:\n{TARGET} DONE\n'


def test_reference_reproduces_patcher_failure_on_mixed_block():
    out, applied, failed = ref.patch(GAME, [MIXED])
    assert applied == [] and len(failed) == 1 and "&amp;quot;" in failed[0]
    assert out == GAME


def test_escaped_only_block_already_applies_and_is_untouched():
    assert ke.pre_escape_replace_blocks(ESCAPED_ONLY) == (ESCAPED_ONLY, 0)
    _, applied, _ = ref.patch(GAME, [ESCAPED_ONLY])
    assert len(applied) == 1


def test_pre_escaped_mixed_block_applies_and_patcher_leaves_it_unchanged():
    text, n = ke.pre_escape_replace_blocks(MIXED)
    assert n == 1 and "<<" not in text and "&amp;" not in text
    assert ref.escape_twine_tags(text) == text
    out, applied, failed = ref.patch(GAME, [text])
    assert failed == [] and "&lt;&lt;set _probe to 1&gt;&gt;" in out and "<p>UNTOUCHED</p>" in out


def test_raw_ampersand_still_escaped_like_patcher():
    text, _ = ke.pre_escape_replace_blocks("Replace:\nA & B <<x>>\nWith:\nC\n")
    assert "A &amp; B &lt;&lt;x&gt;&gt;" in text


def test_canary_passes_required_checks_under_reference_patcher(tmp_path):
    pc.prepare(tmp_path)
    mods = [p.read_text() for p in (tmp_path / "mods").iterdir() if p.name.endswith(".mod")]
    out, _, _ = ref.patch(pc.GAME, mods)
    req, prof, findings = pc.evaluate(out, tmp_path / "mods")
    assert all(req.values()), req
    assert prof["mixed entity + raw macro block applied without pre-escape (recorded only)"][0] is False
    assert findings == ["backslashes in replacement kept literally (intended: yes)"]


@pytest.fixture(scope="module")
def merged(tmp_path_factory):
    d = tmp_path_factory.mktemp("merge")
    for name in ("Mods.zip", "CourseOfTemptation.html"):
        (d / name).symlink_to(ROOT / name)
    run = dict(cwd=d, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    subprocess.run(["git", "init", "-q"], **run)
    subprocess.run(["git", "-c", "user.name=t", "-c", "user.email=t@example.invalid",
                    "commit", "--allow-empty", "-qm", "t"], **run)
    subprocess.run([sys.executable, str(ROOT / ".github/scripts/merge_mods.py")], **run)
    return d / "merge-output/Merged_Mods.zip"


def _cheat(z):
    [name] = [n for n in z.namelist() if n.endswith("m-mod-cheatplus-v0.1.802.mod")]
    return name, z.read(name).decode("utf-8-sig")


def test_real_cheatplus_blocks_now_match(merged):
    game = (ROOT / "CourseOfTemptation.html").read_text(encoding="utf-8")
    with zipfile.ZipFile(ROOT / "Mods.zip") as o, zipfile.ZipFile(merged) as c:
        _, before = _cheat(o)
        name, after = _cheat(c)
        assert "<<" not in after and after.count("Replace:") == before.count("Replace:")
        assert "&amp;quot;" not in after
        def hits(t):
            ok = 0
            for b in t.replace("\r\n", "\n").split("Replace:"):
                b = ref.escape_twine_tags(b)
                if "With:" in b:
                    ok += ref.patch(game, ["Replace:" + b])[1] != []
            return ok
        assert (hits(before), hits(after)) == (8, 28)
        # all other mods untouched except the five reviewed merge groups' files
        changed = {n for n in o.namelist() if n.endswith((".mod", ".Mod")) and o.read(n) != c.read(n)}
        assert name in changed and len(changed) <= 6
