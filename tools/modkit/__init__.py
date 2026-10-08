"""modkit: shared, read-only parsing of KittyPatcher-style mod archives.

Phase 2 status: the library is used by tests and reports only. The
existing workflow scripts and the pinned KittyPatcher remain the build path.
Nothing here applies patches.
"""
from .archive import ArchiveIssue, ModFile, read_archive
from .formats import (
    KITTY, REPLACE_WITH, Block, detect_markers, parse_kitty,
    parse_replace_with, parse_mod,
)
from .match import classify_blocks

__all__ = [
    "ArchiveIssue", "ModFile", "read_archive", "KITTY", "REPLACE_WITH",
    "Block", "detect_markers", "parse_kitty", "parse_replace_with",
    "parse_mod", "classify_blocks",
]
