"""Merger pre-escape that works around KittyPatcher's entity double-escaping."""
import json
import re
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


def _hits(game, text):
    ok = 0
    for b in text.replace("\r\n", "\n").split("Replace:"):
        b = ref.escape_twine_tags(b)
        if "With:" in b:
            ok += ref.patch(game, ["Replace:" + b])[1] != []
    return ok


def test_real_cheatplus_blocks_now_match(merged):
    game = (ROOT / "CourseOfTemptation.html").read_text(encoding="utf-8")
    with zipfile.ZipFile(ROOT / "Mods.zip") as o, zipfile.ZipFile(merged) as c:
        _, before = _cheat(o)
        name, after = _cheat(c)
        assert "<<" not in after and "&amp;quot;" not in after and "<e>" not in after
        # 29 original blocks + inferred r:/w: block + passage insertion block
        assert after.count("Replace:") == before.count("Replace:") + 2
        assert (_hits(game, before), _hits(game, after)) == (8, 30)
        changed = {n for n in o.namelist() if n.endswith((".mod", ".Mod")) and o.read(n) != c.read(n)}
        assert name in changed and len(changed) <= 8  # +AdvtimeSafe, VellicorOiCheatMode targeted fixes


EXPECTED_PASSAGES = ["Cheats+Widget", "Needs+", "m-mod-needs", "Misc+", "m-mod-time", "Teleport+",
                     "TimeCut+", "Internet+", "Lounge+", "Arcade+", "Others+"]


def test_real_added_passages_exist_once_and_resolve(merged):
    game = (ROOT / "CourseOfTemptation.html").read_text(encoding="utf-8")
    with zipfile.ZipFile(merged) as c:
        mods = [c.read(n).decode("utf-8-sig") for n in c.namelist()
                if n.endswith(".mod") and "__MACOSX" not in n]
    out, _, _ = ref.patch(game, mods)
    names = re.findall(r'<tw-passagedata [^>]*name="([^"]*)"', out)
    bodies = dict(re.findall(r'<tw-passagedata [^>]*name="([^"]*)"[^>]*>(.*?)</tw-passagedata>', out, re.S))
    for p in EXPECTED_PASSAGES:
        assert names.count(p) == 1, p
        assert not [r for r in ke.passage_references(bodies[p]) if r not in bodies], p
    sheet = re.search(r'<style[^>]*id="twine-user-stylesheet"[^>]*>(.*?)</style>', out, re.S).group(1)
    assert "Add Passage" not in sheet and "tw-passagedata" not in sheet
    assert "&lt;tw-passagedata" not in out and "&lt;e&gt;" not in out
    assert "&lt;&lt;set $qolmart to 30&gt;&gt;" in out  # inferred r:/w: block applied
    manifest = json.loads((merged.parent / "MergeManifest.json").read_text())
    assert [p["name"] for p in manifest["added_passages"]] == EXPECTED_PASSAGES
    assert len(manifest["inferred_replace_blocks"]) == 1


# --- small fixtures for Add Passage / <e> handling ---------------------------
FIX_GAME = '<tw-storydata><tw-passagedata pid="1" name="Start" tags="" position="1,1" size="1,1">x</tw-passagedata></tw-storydata>'


def _mod(passages, extra=""):
    return "Replace:\nx\nWith:\ny\n\nAdd Passage:\n" + passages + extra


P = '<tw-passagedata pid="900" name="New" tags="nobr" position="1,1" size="1,1">\n<e>\n<<set $a to "b">>\n</e>\n</tw-passagedata>\n'


def test_add_passage_extracted_escaped_and_inserted():
    text, ps, inferred = ke.extract_add_passages(_mod(P))
    assert "Add Passage" not in text and inferred == []
    assert ps[0]["name"] == "New" and ps[0]["body"] == "\n&lt;&lt;set $a to &quot;b&quot;&gt;&gt;\n"
    assert ke.validate_passages(ps, FIX_GAME) == []
    out, applied, failed = ref.patch(FIX_GAME, [text + ke.passage_block(ps)])
    assert out.count('<tw-passagedata pid="900" name="New"') == 1 and out.endswith("</tw-storydata>")


def test_conflicts_and_bad_payload_are_reported():
    dup = P + P.replace('pid="900"', 'pid="901"')
    _, ps, _ = ke.extract_add_passages(_mod(dup))
    assert any("name conflict" in e for e in ke.validate_passages(ps, FIX_GAME))
    _, ps, _ = ke.extract_add_passages(_mod(P.replace('pid="900" name="New"', 'pid="1" name="Other"')))
    assert any("id conflict" in e for e in ke.validate_passages(ps, FIX_GAME))
    _, ps, _ = ke.extract_add_passages(_mod(P.replace('name="New"', 'name="Start"')))
    assert any("name conflict" in e for e in ke.validate_passages(ps, FIX_GAME))
    _, ps, _ = ke.extract_add_passages(_mod(P.replace("b", "\\d")))
    assert any("Backslash" in e for e in ke.validate_passages(ps, FIX_GAME))
    assert any("exactly once" in e for e in ke.validate_passages([], FIX_GAME * 2))


@pytest.mark.parametrize("bad", [
    P.replace("</e>\n", ""),                       # unclosed
    P.replace("<e>\n", "<e> inline\n"),            # inline marker
    P.replace("\n<e>\n", "\n<b>raw</b>\n<e>\n"),   # raw markup outside <e>
    P + "stray text\n",                           # unrecognized leftover
])
def test_malformed_sections_fail_loudly(bad):
    with pytest.raises(ke.ModFormatError):
        ke.extract_add_passages(_mod(bad))


def test_add_javascript_is_rejected():
    with pytest.raises(ke.ModFormatError):
        ke.extract_add_passages("Add Javascript:\nfoo\n")


def test_short_rw_leftover_becomes_inferred_replace_block():
    text, _, inferred = ke.extract_add_passages(_mod(P, "\nr:\nx\nw:\n<e>\n<<set $q to 1>>\n</e>\n"))
    assert inferred == ["x"] and "\nReplace:\nx\nWith:\n" in text


def test_e_markers_in_replace_block_escaped_and_removed():
    text, n = ke.pre_escape_replace_blocks("Replace:\nfoo\nWith:\n<e>\n<<set $x to \"y\">>\n</e>\n")
    assert n == 1 and "<e>" not in text and "&lt;&lt;set $x to &quot;y&quot;&gt;&gt;" in text


def test_playtest_fixes_time_wrapper_and_reroll_script(merged):
    """Fresh-game playtest: <<advtime>> called an undefined safeadvance_time,
    and Reroll RNG had <<if>> inside <<script>>."""
    game = (ROOT / "CourseOfTemptation.html").read_text(encoding="utf-8")
    with zipfile.ZipFile(merged) as c:
        texts = [c.read(n).decode("utf-8-sig") for n in c.namelist() if n.endswith(".mod")]
    out, _, _ = ref.patch(game, texts)
    assert out.count("setup.Time.safeadvance_time = function") == 1
    assert out.count("setup.Time.advance_time = function(minutes)") == 1
    assert "this.wet_clothes(minutes);" in out  # game's v0.8.4d body kept
    assert "setup.Time.safeadvance_time(_args[0])" in out
    i = out.index("Reroll RNG")
    script = out[i:].split("&lt;&lt;script&gt;&gt;", 1)[1].split("&lt;&lt;/script&gt;&gt;", 1)[0]
    assert "&lt;&lt;" not in script and "if (State.prng.isEnabled()) {" in script
    manifest = json.loads((merged.parent / "MergeManifest.json").read_text(encoding="utf-8"))
    assert len(manifest["targeted_fixes"]) == 2
