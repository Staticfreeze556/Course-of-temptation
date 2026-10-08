"""Fixture tests for tools/modkit parsing (synthetic archives)."""
import io
import zipfile

import pytest

from modkit import (KITTY, REPLACE_WITH, parse_kitty, parse_mod,
                    parse_replace_with, read_archive)


def make_zip(tmp_path, files):
    p = tmp_path / "t.zip"
    with zipfile.ZipFile(p, "w") as z:
        for name, data in files.items():
            z.writestr(name, data)
    return p


def test_kitty_basic_split_and_strip():
    b = parse_kitty("  a \n~ b ~~c~d~~")
    assert [(x.find, x.replace, x.index) for x in b] == [("a", "b", 0), ("c", "d", 1)]
    assert all(x.fmt == KITTY for x in b)


def test_kitty_tilde_inside_replacement_splits_once():
    (b,) = parse_kitty("x~y ~ z")
    assert b.find == "x" and b.replace == "y ~ z"


def test_kitty_trailing_and_empty_segments_ignored():
    assert parse_kitty("~~~~") == []
    assert parse_kitty("no tilde here") == []


def test_kitty_empty_find_is_kept_for_reporting():
    (b,) = parse_kitty("~replacement")
    assert b.find == ""


def test_replace_with_multi_block():
    t = "Replace:\nfoo\nWith:\nbar\nReplace:\n  baz\nWith:\nqux With: kept\n"
    b = parse_replace_with(t)
    assert [(x.find, x.replace) for x in b] == [("foo", "bar"), ("baz", "qux With: kept")]
    assert all(x.fmt == REPLACE_WITH for x in b)


def test_archive_rules(tmp_path):
    p = make_zip(tmp_path, {
        "d/a.mod": b"\xef\xbb\xbfx~y\r\n",
        "d/B.Mod": "p~q",
        "__MACOSX/._d": "meta",
        "d/._a.mod": "meta",
        "../evil.mod": "x~y",
        "d/A.MOD": "dup~dup",
        "d/readme.txt": "hi",
        "d/bad.mod": b"\xff\xfe",
    })
    r = read_archive(p)
    paths = [m.path for m in r.mods]
    assert paths == ["d/a.mod", "d/B.Mod"]
    a = r.mods[0]
    assert a.had_bom and a.had_crlf and a.text == "x~y\n"
    assert r.mods[1].lowercase_extension is False
    assert r.skipped_metadata == ["__MACOSX/._d", "d/._a.mod"]
    assert r.other_files == ["d/readme.txt"]
    msgs = {(i.severity, i.path, i.message.split(":")[0]) for i in r.issues}
    assert ("blocker", "../evil.mod", "Unsafe archive path") in msgs
    assert ("blocker", "d/bad.mod", "Invalid UTF-8") in msgs
    assert any(i.path == "d/B.Mod" and i.severity == "warning" for i in r.issues)
    # 'd/A.MOD' differs from 'd/a.mod' only by case -> blocker, not silently merged
    assert ("blocker", "d/A.MOD", "Duplicate case-insensitive archive path") in msgs


def test_parse_mod_reports_unhandled_markers(tmp_path):
    p = make_zip(tmp_path, {"m.mod": "Replace:\na\nWith:\nb\nAdd Passage: X\n<e>\n"})
    (m,) = read_archive(p).mods
    blocks, notes = parse_mod(m)
    assert len(blocks) == 1
    assert any("Add Passage:" in n for n in notes)
    assert any("<e>" in n for n in notes)


def test_parse_mod_flags_both_formats(tmp_path):
    p = make_zip(tmp_path, {"m.mod": "x~y\nReplace:\na\nWith:\nb"})
    (m,) = read_archive(p).mods
    blocks, notes = parse_mod(m)
    assert {b.fmt for b in blocks} == {KITTY, REPLACE_WITH}
    assert any("both formats" in n for n in notes)
