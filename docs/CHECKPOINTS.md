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

## Phase 2b: latest-release patcher selection (branch `pipeline-revamp-latest-patcher`, PR into `pipeline-revamp-phase2`)

### Why
Owner clarification: KittyPatcher updates arrive as GitHub Releases, and builds must follow the latest one without code edits. The Phase 1 permanent pin is superseded. v0.1.2 remains a historical baseline.

### Changes
- `.github/scripts/select_patcher.py`: resolve once, download by asset ID, digest verification (or explicit owner approval), layout-agnostic EXE selection.
- `.github/scripts/patcher_canary.py`: synthetic-input behavior checks that run before the real patch.
- `.github/scripts/build_record.py`: `BuildRecord.json`.
- `.github/patcher-baselines.json`: v0.1.2 baseline (not a pin).
- `merge.yml`: new inputs `approve_unverified_patcher_sha256` (default empty) and `accept_patcher_behavior_findings` (default false). New steps: resolve, download, verify, canary, run, record. The badge shows the build label and patcher tag.
- **Test change, stated explicitly:** the Phase 1 tests `test_patcher_is_pinned_not_latest` and `test_patcher_exe_pinned_and_not_recursive` encoded the superseded pin requirement and were **replaced** by tests for the new requirement (resolve exactly once, no hard-coded identity, step order, selection reuse, approval inputs, record upload). They weren't removed to make anything pass.

### Tests (local): 56 passed
- End to end against a local fake GitHub API: publishing a newer valid release (new tag, asset name and folder layout, single EXE) changes the selected patcher with the workflow and scripts byte-identical before and after.
- A release published between resolve and download doesn't change the selection, and `releases/latest` is called once.
- Missing digest stops the build, a wrong approval fails, and the correct approval proceeds with mode `owner-approved-without-published-digest`.
- Failures: digest mismatch, no or ambiguous asset, prerelease, no EXE, different EXEs, unsafe ZIP path. Identical copies collapse, as with v0.1.2.
- Canary logic: an intended-literal patcher produces no findings; backslash rewriting and entity re-escaping are findings; a missing required replacement fails; findings block unless accepted, which yields a diagnostic label.
- Local sanity run of the canary against KittyPatcher's **bundled .py source** (not the EXE): required checks pass. Finding: backslashes rewritten. Recorded: multi-match replaced 2 of 2, `.Mod` not loaded, LF output.

### Not tested / limitations
- The new `merge.yml` steps haven't run on Windows. The EXE's canary profile is unknown until a run, and from run 37733625592 it's expected to show at least the entity finding, which would stop the build until findings are accepted.
- Real GitHub API behavior (redirect to asset storage with the token removed) is tested only by code reading. The fake server doesn't redirect.
- Canary coverage is limited to the listed behaviors. It doesn't prove equivalence on the real game.
- No gameplay or save testing.

## Phase 3: one-file AI handoff (branch `pipeline-revamp-handoff`, PR into `pipeline-revamp-latest-patcher`)
- Added `.github/scripts/make_handoff.py`, wired into `inspect.yml` and `merge.yml` with `if: always()`, plus `tests/test_handoff.py` (7 tests).
- Tests: 63 passed locally. They cover normal generation, missing evidence, a blocked behavior check (reported, not bypassed), evidence reduction under a size limit with full code, a limit too small (INCOMPLETE, whole-file omission, no partial code), no baseline and with a baseline, and real inputs (complete, ≤ 600 KB, merger embedded verbatim).
- Limitations: if the Linux merge job fails, the Windows job doesn't run and no build handoff is produced (Inspect's handoff still exists). Candidate context comes from a simple text search and is unverified. Deferred: production parser migration, automatic baseline retrieval.
