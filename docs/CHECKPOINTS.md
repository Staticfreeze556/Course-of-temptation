# Checkpoints

## Phase 1: baseline, docs, patcher pin (branch `pipeline-revamp`)

### Changes
- `merge.yml`: KittyPatcher pinned to release `kitty-patcher` / `KittyPatcher.v0.1.2.zip`, ZIP and EXE SHA256 verified before running. Uses the root EXE (fixes the two-EXE recursive-search failure).
- Added `README.md`, `docs/AI-HANDOFF.md` (both required by `inspect.yml`), `docs/PIPELINE.md`, `docs/BASELINE.md`, and the generated `docs/INVENTORY.md`.
- Added `tools/inventory.py` (read-only). It reports unsupported formats as `UNSUPPORTED_FORMAT_NOT_INSPECTED`.
- Added `tests/` (pytest) and `.github/workflows/tests.yml`.
- **Not changed:** `CourseOfTemptation.html`, `Mods.zip`, all `.github/scripts/*`, `prepare.yml`, `inspect.yml`.

### Tests (local, Python 3.11, pytest)
15 passed: original hashes, game version, inventory reconciliation (55 = 52 + 2 + 1), cheatplus not inspected (29 blocks), `.Mod` flagged, mixed-format synthetic ZIP, inspector golden baseline (REVIEW REQUIRED, 0 blockers, 5 warnings, 68/5/87/6), workflow YAML parse, patcher pin, EXE pin, inspect bundle files present.
The bundle-file test failed before the docs were added and passes after.
- Verified: the downloaded `KittyPatcher.v0.1.2.zip` SHA256 equals GitHub's published digest `b105af5a…71d6d8`.

### Not tested / limitations
- `merge.yml`'s Windows job wasn't run. PowerShell changes are only checked statically (YAML parse plus string checks). It needs a manual `workflow_dispatch` on the branch.
- Whether the EXE matches its bundled `.py` source is unverified (see BASELINE K1–K9).
- No gameplay, browser or save testing.
- The modded build is still expected to be mostly non-functional because of the 0.5.4g → 0.8.4d mismatch.
