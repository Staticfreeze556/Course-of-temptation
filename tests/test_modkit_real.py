"""modkit against the real inputs: equivalence with the existing inspector."""
import collections

import pytest

from conftest import ARCHIVE, GAME
from modkit import KITTY, REPLACE_WITH, classify_blocks, parse_mod, read_archive
from test_inspect_baseline import data  # noqa: F401  (reuse module fixture)

CHEAT = "Mods -version 0.5.4g/m-mod-cheatplus-v0.1.802.mod"


@pytest.fixture(scope="module")
def parsed():
    r = read_archive(ARCHIVE)
    blocks, notes = [], {}
    for m in r.mods:
        b, n = parse_mod(m)
        blocks += b
        notes[m.path] = n
    return r, blocks, notes


def test_archive_counts(parsed):
    r, _, _ = parsed
    assert len(r.mods) == 52
    assert r.skipped_metadata == ["__MACOSX/._Mods -version 0.5.4g"]
    assert [i for i in r.issues if i.severity == "blocker"] == []
    assert [m.path for m in r.mods if not m.lowercase_extension] == [
        "Mods -version 0.5.4g/KittyDateAnybody.Mod"]


def test_kitty_entries_identical_to_inspector(parsed, data):
    _, blocks, _ = parsed
    mine = [(b.mod, b.index, b.find, b.replace) for b in blocks if b.fmt == KITTY]
    theirs = [(e["file"], e["segment_index"], e["target"], e["replacement"])
              for e in data["entries"]]
    assert mine == theirs


def test_kitty_classification_identical_to_inspector(parsed, data):
    _, blocks, _ = parsed
    game = GAME.read_text(encoding="utf-8")
    res, shared = classify_blocks([b for b in blocks if b.fmt == KITTY], game)
    assert [c for _, c, _ in res] == [e["finding"] for e in data["entries"]]
    assert len(shared) == 11


def test_cheatplus_parsed_and_reported(parsed):
    _, blocks, notes = parsed
    cb = [b for b in blocks if b.mod == CHEAT]
    assert len(cb) == 29 and {b.fmt for b in cb} == {REPLACE_WITH}
    assert any("Add Passage:" in n for n in notes[CHEAT])
    assert any("<e>" in n for n in notes[CHEAT])
    # No other mod uses Replace:/With:
    assert {b.mod for b in blocks if b.fmt == REPLACE_WITH} == {CHEAT}


def test_cheatplus_match_counts_recorded(parsed):
    _, blocks, _ = parsed
    game = GAME.read_text(encoding="utf-8")
    res, _ = classify_blocks([b for b in blocks if b.mod == CHEAT], game)
    counts = collections.Counter(c for _, c, _ in res)
    assert counts == {
        "One exact original match": 24,
        "Multiple exact original matches": 4,
        "Possible whitespace-only difference": 1,
    }
