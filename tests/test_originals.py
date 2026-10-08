"""The original game and mod archive must stay byte-identical."""
import hashlib

from conftest import ARCHIVE, ARCHIVE_SHA256, GAME, GAME_SHA256


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def test_game_unchanged():
    assert sha(GAME) == GAME_SHA256


def test_archive_unchanged():
    assert sha(ARCHIVE) == ARCHIVE_SHA256


def test_game_version_is_084d():
    text = GAME.read_text(encoding="utf-8")
    assert "v0.8.4d" in text
    assert 'format-version="2.36.1"' in text
