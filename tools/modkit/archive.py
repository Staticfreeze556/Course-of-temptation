"""Safe, read-only iteration over .mod files in a ZIP. Never extracts."""
import hashlib
import zipfile
from dataclasses import dataclass, field
from pathlib import Path, PurePosixPath


@dataclass
class ArchiveIssue:
    severity: str          # "blocker" | "warning"
    path: str
    message: str


@dataclass
class ModFile:
    path: str
    raw: bytes
    text: str              # BOM removed, CRLF -> LF
    sha256: str
    had_bom: bool
    had_crlf: bool
    lowercase_extension: bool   # False for e.g. ".Mod" (KittyPatcher skips these)


@dataclass
class ArchiveResult:
    mods: list = field(default_factory=list)
    issues: list = field(default_factory=list)
    skipped_metadata: list = field(default_factory=list)
    directories: list = field(default_factory=list)
    other_files: list = field(default_factory=list)


def _unsafe(path):
    return path.is_absolute() or ".." in path.parts or (
        path.parts and ":" in path.parts[0])


def read_archive(archive_path):
    res = ArchiveResult()
    seen = set()
    with zipfile.ZipFile(Path(archive_path)) as zf:
        bad = zf.testzip()
        if bad is not None:
            res.issues.append(ArchiveIssue("blocker", bad, "ZIP CRC check failed"))
        for info in zf.infolist():
            name = info.filename.replace("\\", "/")
            path = PurePosixPath(name)
            if info.is_dir():
                res.directories.append(name)
                continue
            if _unsafe(path):
                res.issues.append(ArchiveIssue("blocker", name, "Unsafe archive path"))
                continue
            if "__MACOSX" in path.parts or path.name.startswith("._"):
                res.skipped_metadata.append(name)
                continue
            key = name.casefold()
            if key in seen:
                res.issues.append(ArchiveIssue(
                    "blocker", name, "Duplicate case-insensitive archive path"))
                continue
            seen.add(key)
            if not name.lower().endswith(".mod"):
                res.other_files.append(name)
                continue
            raw = zf.read(info)
            try:
                text = raw.decode("utf-8-sig")
            except UnicodeDecodeError as exc:
                res.issues.append(ArchiveIssue("blocker", name, f"Invalid UTF-8: {exc}"))
                continue
            norm = text.replace("\r\n", "\n")
            if "\r" in norm:
                res.issues.append(ArchiveIssue(
                    "warning", name, "Standalone carriage return"))
            lower = name.endswith(".mod")
            if not lower:
                res.issues.append(ArchiveIssue(
                    "warning", name,
                    "Extension is not lowercase '.mod'; KittyPatcher v0.1.2 "
                    "source only loads files ending in '.mod'"))
            res.mods.append(ModFile(
                path=name, raw=raw, text=norm,
                sha256=hashlib.sha256(raw).hexdigest(),
                had_bom=raw.startswith(b"\xef\xbb\xbf"),
                had_crlf=b"\r\n" in raw, lowercase_extension=lower,
            ))
    return res
