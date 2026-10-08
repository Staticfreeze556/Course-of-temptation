from __future__ import annotations

import hashlib
import json
import os
import re
import subprocess
import zipfile
from pathlib import Path, PurePosixPath

EXPECTED_GAME_VERSION = "v0.8.4d"
EXPECTED_MOD_COUNT = 52
SCHEMA_VERSION = 2

ROOT = Path(".")
SOURCE = ROOT / "Mods.zip"
GAME = ROOT / "CourseOfTemptation.html"


def sha256(path: Path) -> str:
    h = hashlib.sha256()

    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            h.update(chunk)

    return h.hexdigest()


def git_commit() -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            text=True,
        ).strip()
    except Exception:
        return "unknown"


def repository() -> str:
    return os.environ.get("GITHUB_REPOSITORY", "")


def run_id() -> str:
    return os.environ.get("GITHUB_RUN_ID", "")


def game_version(game_text: str) -> list[str]:
    import html

    return sorted(
        set(
            re.findall(
                r'Config\.saves\.version\s*(?:=|to)\s*["\'](v[^"\'\s<>]+)["\']',
                html.unescape(game_text),
            )
        )
    )


def normalize_mod_text(raw: bytes) -> tuple[str, bool, str]:
    bom = raw.startswith(b"\xef\xbb\xbf")

    text = raw.decode("utf-8-sig").replace(
        "\r\n",
        "\n",
    )

    if "\r" in text:
        raise ValueError(
            "contains standalone carriage-return characters"
        )

    newline = "\r\n" if b"\r\n" in raw else "\n"

    return text, bom, newline


def validate_archive(
    path: Path,
    *,
    require_mods: bool = True,
) -> list[dict]:

    records = []
    seen = set()

    with zipfile.ZipFile(path) as archive:

        bad = archive.testzip()

        if bad is not None:
            raise ValueError(
                f"ZIP integrity check failed at {bad}"
            )

        for info in archive.infolist():

            if info.is_dir():
                continue

            name = info.filename.replace("\\", "/")
            p = PurePosixPath(name)

            if p.is_absolute() or ".." in p.parts:
                raise ValueError(
                    f"unsafe archive path: {name}"
                )

            if p.parts and ":" in p.parts[0]:
                raise ValueError(
                    f"unsafe archive path: {name}"
                )

            if "__MACOSX" in p.parts or p.name.startswith("._"):
                continue

            key = name.casefold()

            if key in seen:
                raise ValueError(
                    f"duplicate case-insensitive archive path: {name}"
                )

            seen.add(key)

            records.append(
                {
                    "name": name,
                    "data": archive.read(info),
                }
            )

    mods = [
        r
        for r in records
        if r["name"].lower().endswith(".mod")
    ]

    if require_mods and not mods:
        raise ValueError(
            "archive contains no .mod files"
        )

    return records


def parsed_entries(text: str) -> list[dict]:
    entries = []

    for index, segment in enumerate(text.split("~~")):

        if "~" not in segment:
            continue

        old, new = segment.split("~", 1)

        entries.append(
            {
                "segment_index": index,
                "target": old.strip(),
                "replacement": new.strip(),
            }
        )

    return entries


def short(
    text: str,
    limit: int = 180,
) -> str:

    text = re.sub(
        r"\s+",
        " ",
        text,
    ).strip()

    return (
        text[:limit]
        + ("..." if len(text) > limit else "")
    )


def md(text: str) -> str:
    return (
        text
        .replace("`", "'")
        .replace("|", r"\|")
    )


def write_summary(text: str) -> None:
    path = os.environ.get(
        "GITHUB_STEP_SUMMARY"
    )

    if path:
        with open(
            path,
            "a",
            encoding="utf-8",
        ) as fh:
            fh.write(
                text.rstrip() + "\n\n"
            )


def write_output(
    key: str,
    value: str,
) -> None:

    path = os.environ.get(
        "GITHUB_OUTPUT"
    )

    if path:
        with open(
            path,
            "a",
            encoding="utf-8",
        ) as fh:
            fh.write(
                f"{key}={value}\n"
            )


def load_json(path: Path) -> dict:
    with path.open(
        "r",
        encoding="utf-8",
    ) as fh:
        value = json.load(fh)

    if not isinstance(value, dict):
        raise ValueError(
            f"{path} must contain a JSON object"
        )

    return value


def write_json(
    path: Path,
    value: dict,
) -> None:

    path.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    path.write_text(
        json.dumps(
            value,
            indent=2,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
    )
