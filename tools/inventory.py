"""Read-only inventory of Mods.zip.

Lists every archive entry and classifies each .mod file by patch format.
Files in a format the pipeline cannot interpret are reported as
UNSUPPORTED_FORMAT_NOT_INSPECTED, never as inspected.

Usage: python tools/inventory.py [Mods.zip] [--json OUT] [--md OUT]
Standard library only. Never extracts or executes archive contents.
"""
import argparse
import hashlib
import json
import re
import sys
import zipfile
from pathlib import Path, PurePosixPath

KITTY = "kitty-tilde"            # find~replace~~find~replace
REPLACE_WITH = "replace-with"    # Replace:\n...\nWith:\n...
SUPPORTED = {KITTY}


def classify(text):
    text = text.replace("\r\n", "\n")
    kitty_blocks = sum(1 for seg in text.split("~~") if "~" in seg)
    rw_blocks = len(re.findall(r"^Replace:\s*$", text, re.M))
    other = []
    if re.search(r"^Add Passage:", text, re.M):
        other.append("Add Passage:")
    if "<e>" in text:
        other.append("<e>")
    formats = []
    if kitty_blocks:
        formats.append(KITTY)
    if rw_blocks:
        formats.append(REPLACE_WITH)
    formats += other
    # A Replace/With file may contain stray "~" in CSS/JS; only treat as
    # kitty when no other format marker is present.
    if rw_blocks or other:
        status = "UNSUPPORTED_FORMAT_NOT_INSPECTED"
    elif kitty_blocks:
        status = "SUPPORTED"
    else:
        status = "UNRECOGNIZED_NOT_INSPECTED"
    return {
        "formats": formats,
        "kitty_blocks": kitty_blocks if status == "SUPPORTED" else 0,
        "replace_with_blocks": rw_blocks,
        "status": status,
    }


def build(archive_path):
    archive_path = Path(archive_path)
    data = archive_path.read_bytes()
    result = {
        "archive": str(archive_path),
        "archive_sha256": hashlib.sha256(data).hexdigest(),
        "entries_total": 0,
        "directories": [],
        "metadata_entries": [],
        "other_files": [],
        "mods": [],
    }
    with zipfile.ZipFile(archive_path) as zf:
        for info in zf.infolist():
            result["entries_total"] += 1
            name = info.filename
            path = PurePosixPath(name)
            if info.is_dir():
                result["directories"].append(name)
                continue
            if "__MACOSX" in path.parts or path.name.startswith("._"):
                result["metadata_entries"].append(name)
                continue
            if not name.lower().endswith(".mod"):
                result["other_files"].append(name)
                continue
            raw = zf.read(info)
            text = raw.decode("utf-8-sig", errors="replace")
            rec = {
                "path": name,
                "bytes": info.file_size,
                "sha256": hashlib.sha256(raw).hexdigest(),
                "extension_case_nonstandard": not name.endswith(".mod"),
            }
            rec.update(classify(text))
            result["mods"].append(rec)
    mods = result["mods"]
    result["summary"] = {
        "mod_files": len(mods),
        "supported": sum(m["status"] == "SUPPORTED" for m in mods),
        "not_inspected": [m["path"] for m in mods if m["status"] != "SUPPORTED"],
        "kitty_blocks": sum(m["kitty_blocks"] for m in mods),
        "uninspected_replace_with_blocks": sum(
            m["replace_with_blocks"] for m in mods if m["status"] != "SUPPORTED"
        ),
    }
    return result


def markdown(inv):
    s = inv["summary"]
    out = [
        "# Mods.zip inventory",
        "",
        f"- Archive SHA256: `{inv['archive_sha256']}`",
        f"- Archive entries: {inv['entries_total']} = {s['mod_files']} .mod files"
        f" + {len(inv['directories'])} directories"
        f" + {len(inv['metadata_entries'])} macOS metadata"
        f" + {len(inv['other_files'])} other files",
        f"- Supported (inspected) mods: {s['supported']}"
        f" with {s['kitty_blocks']} find~replace blocks",
        f"- NOT inspected: {len(s['not_inspected'])} file(s),"
        f" {s['uninspected_replace_with_blocks']} Replace/With blocks",
        "",
        "| Mod | Status | Formats | ~ blocks | Replace/With blocks |",
        "|---|---|---|---|---|",
    ]
    for m in inv["mods"]:
        out.append(
            f"| `{m['path']}` | {m['status']} | {', '.join(m['formats']) or '-'}"
            f" | {m['kitty_blocks']} | {m['replace_with_blocks']} |"
        )
    out += ["", "Non-mod entries:", ""]
    out += [f"- directory: `{d}`" for d in inv["directories"]]
    out += [f"- metadata (ignored): `{d}`" for d in inv["metadata_entries"]]
    out += [f"- other: `{d}`" for d in inv["other_files"]]
    return "\n".join(out) + "\n"


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("archive", nargs="?", default="Mods.zip")
    ap.add_argument("--json")
    ap.add_argument("--md")
    a = ap.parse_args(argv)
    inv = build(a.archive)
    if a.json:
        Path(a.json).write_text(json.dumps(inv, indent=2) + "\n", encoding="utf-8")
    md = markdown(inv)
    if a.md:
        Path(a.md).write_text(md, encoding="utf-8")
    else:
        sys.stdout.write(md)
    return 0


if __name__ == "__main__":
    sys.exit(main())
