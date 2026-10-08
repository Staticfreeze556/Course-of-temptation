import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

GAME = ROOT / "CourseOfTemptation.html"
ARCHIVE = ROOT / "Mods.zip"

# Baseline identities of the original, never-modified inputs (commit dafa50b).
GAME_SHA256 = "3fd11525d5bc9a94501c210f101b27069e98bce39c090f6285d54433589526b4"
ARCHIVE_SHA256 = "06c6ddd786b559c9b1e991b9baec2b730e394c10443cee3f2293d731726cacc6"

# Pinned KittyPatcher release (verified against the GitHub-published digest).
PATCHER_ZIP_SHA256 = "b105af5a3b73e4e4387d20e3eb67013f25a4a0b13a58a2b9a820a7a03b71d6d8"
PATCHER_EXE_SHA256 = "872051498db367f6ce74060708f38ae8703de280f0365e967f9e347f58ee752b"
