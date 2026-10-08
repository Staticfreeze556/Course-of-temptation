"""Inventory reconciliation and unsupported-format reporting."""
import io
import zipfile

import inventory
from conftest import ARCHIVE

CHEAT = "Mods -version 0.5.4g/m-mod-cheatplus-v0.1.802.mod"


def inv():
    return inventory.build(ARCHIVE)


def test_entry_reconciliation():
    i = inv()
    # 55 entries = 52 .mod + 2 directories + 1 __MACOSX metadata.
    assert i["entries_total"] == 55
    assert i["summary"]["mod_files"] == 52
    assert len(i["directories"]) == 2
    assert i["metadata_entries"] == ["__MACOSX/._Mods -version 0.5.4g"]
    assert i["other_files"] == []
    assert (
        i["summary"]["mod_files"] + len(i["directories"])
        + len(i["metadata_entries"]) + len(i["other_files"])
        == i["entries_total"]
    )


def test_supported_counts():
    s = inv()["summary"]
    assert s["supported"] == 51
    assert s["kitty_blocks"] == 166


def test_cheatplus_reported_not_inspected():
    i = inv()
    rec = next(m for m in i["mods"] if m["path"] == CHEAT)
    assert rec["status"] == "UNSUPPORTED_FORMAT_NOT_INSPECTED"
    assert rec["replace_with_blocks"] == 29
    assert rec["kitty_blocks"] == 0
    assert i["summary"]["not_inspected"] == [CHEAT]
    assert i["summary"]["uninspected_replace_with_blocks"] == 29
    md = inventory.markdown(i)
    assert "NOT inspected: 1 file(s), 29 Replace/With blocks" in md


def test_uppercase_extension_counted_and_flagged():
    rec = next(m for m in inv()["mods"] if m["path"].endswith(".Mod"))
    assert rec["status"] == "SUPPORTED"
    assert rec["extension_case_nonstandard"] is True


def _zip(files):
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as z:
        for n, t in files.items():
            z.writestr(n, t)
    buf.seek(0)
    return buf


def test_mixed_format_is_never_marked_supported(tmp_path):
    p = tmp_path / "m.zip"
    p.write_bytes(_zip({
        "a.mod": "x~y~~p~q",
        "b.mod": "a~b\nReplace:\nfoo\nWith:\nbar\n",
        "c.mod": "no markers at all",
    }).read())
    by = {m["path"]: m for m in inventory.build(p)["mods"]}
    assert by["a.mod"]["status"] == "SUPPORTED"
    assert by["b.mod"]["status"] == "UNSUPPORTED_FORMAT_NOT_INSPECTED"
    assert by["c.mod"]["status"] == "UNRECOGNIZED_NOT_INSPECTED"
