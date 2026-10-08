"""Mod patch formats.

Both parsers mirror KittyPatcher v0.1.2's bundled source and the repo's
existing scripts: split, then strip() find and replacement text.

- kitty-tilde:  "find~replace~~find~replace"  (split on "~~", then first "~")
- replace-with: "Replace:\\nfind\\nWith:\\nreplace" (split on "Replace:",
  then first "With:")

`Add Passage:` and `<e>` markers have no handler in KittyPatcher v0.1.2;
they are detected and reported, never interpreted.
"""
import re
from dataclasses import dataclass

KITTY = "kitty-tilde"
REPLACE_WITH = "replace-with"


@dataclass(frozen=True)
class Block:
    mod: str
    fmt: str
    index: int        # segment index in the split (matches inspector's segment_index for kitty)
    find: str
    replace: str


def parse_kitty(text, mod=""):
    out = []
    for i, seg in enumerate(text.split("~~")):
        if "~" not in seg:
            continue
        old, new = seg.split("~", 1)
        out.append(Block(mod, KITTY, i, old.strip(), new.strip()))
    return out


def parse_replace_with(text, mod=""):
    out = []
    for i, seg in enumerate(text.split("Replace:")):
        if "With:" not in seg:
            continue
        old, new = seg.split("With:", 1)
        out.append(Block(mod, REPLACE_WITH, i, old.strip(), new.strip()))
    return out


def detect_markers(text):
    m = []
    if "Replace:" in text and "With:" in text:
        m.append("Replace:/With:")
    if re.search(r"^Add Passage:", text, re.M):
        m.append("Add Passage:")
    if "<e>" in text:
        m.append("<e>")
    return m


def parse_mod(mod_file):
    """Return (blocks, notes). Runs both parsers like KittyPatcher does,
    and records which formats produced blocks."""
    text = mod_file.text
    kitty = parse_kitty(text, mod_file.path)
    rw = parse_replace_with(text, mod_file.path)
    markers = detect_markers(text)
    notes = []
    if kitty and rw:
        notes.append("both formats produced blocks; KittyPatcher would load both")
    for unhandled in ("Add Passage:", "<e>"):
        if unhandled in markers:
            notes.append(f"'{unhandled}' marker present; not interpreted by any parser")
    if not kitty and not rw:
        notes.append("no blocks parsed")
    return kitty + rw, notes
