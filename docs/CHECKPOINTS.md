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

## Diagnostic run 37732423437 (on Phase 1 head `c2eb933`)
Stopped at candidate inspection because of the Windows CRLF checkout. KittyPatcher didn't run. See [DIAGNOSTIC-RUN-37732423437.md](DIAGNOSTIC-RUN-37732423437.md).

## Phase 2: fixture tests and shared parsing (branch `pipeline-revamp-phase2`, PR into `pipeline-revamp`)

### Changes
- `.gitattributes`: `* -text` (byte-identical checkouts on Windows). This fixes the diagnostic-run blockers. **Not yet re-run on Windows.**
- `tools/modkit/`: shared read-only library. `archive.py` (safe ZIP reading), `formats.py` (kitty `~`/`~~` and `Replace:`/`With:` parsers, using KittyPatcher-equivalent split and strip), `match.py` (exact-match classification, report only).
- `tools/compat_report.py` and the generated `docs/COMPATIBILITY.md`: per-mod matrix covering all 52 mods, including cheatplus.
- **Not changed:** the build path. The existing scripts, KittyPatcher, patch order and exact matching are untouched. modkit isn't wired into any workflow.

### Tests (local): 30 passed
- Fixtures: split and strip, `~` inside a replacement, empty and trailing segments, empty find kept for reporting, multi-block Replace/With, BOM/CRLF, `__MACOSX`/`._`, unsafe `../` path, case-insensitive duplicates, invalid UTF-8, `.Mod` flagged, unhandled `Add Passage:`/`<e>` reported, mixed-format file.
- Real inputs: modkit's 166 kitty blocks are **identical** (file, index, find, replace) to the existing inspector's entries. Classification is identical. 11 shared targets.
- cheatplus: 29 Replace/With blocks parsed. 24 match exactly once, 4 multiple times, 1 differs only in whitespace. It's the only mod using that format.
- `.gitattributes` present; `COMPATIBILITY.md` is current.

### Findings
- Including cheatplus: 17 mods match fully, 13 partially (KittyPatcher would partially apply these), and 22 not at all.

### Not tested / limitations
- Windows re-run done: see DIAGNOSTIC-RUN-37733625592.md.
- modkit's equivalence with `merge_mods.py` and `check_candidate.py` is by code reading, not executed comparison. Those scripts aren't migrated to modkit yet.
- KittyPatcher behaviors K3–K9 aren't yet observed in a real run.
- No gameplay or save testing.

## Diagnostic run 37733625592 (on Phase 2 head `722912e`)
All checks passed and KittyPatcher ran: 73 applied, 105 failed. Output SHA256 `070fd80f…52de`. Diagnostic baseline: gameplay and save compatibility unverified. The EXE likely differs from its bundled source (cheatplus escaping). See [DIAGNOSTIC-RUN-37733625592.md](DIAGNOSTIC-RUN-37733625592.md).
