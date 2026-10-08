# Pipeline details

## Ground rules
- `CourseOfTemptation.html` and `Mods.zip` are never modified. `tests/test_originals.py` enforces their hashes.
- Nothing from `Mods.zip` is executed. Mods are read as text.
- Mods in formats the pipeline can't interpret are reported as `UNSUPPORTED_FORMAT_NOT_INSPECTED`, never as inspected (`tools/inventory.py`).
- Failing tests are not removed or skipped to make CI green.

## Patcher selection (latest release, resolved once)
Owner's update process: upload a new game HTML or new mods to the repo, and publish
KittyPatcher as a **GitHub Release**. The next build uses the newest release, with no code edits.

Per build, in `merge.yml`'s Windows job:
1. **Resolve once.** `select_patcher.py resolve` calls `releases/latest` exactly once and records the release ID, tag, name, published time and the selected asset (ID, name, size, published digest) in `work/_patcher/selection.json`. Nothing later asks for "latest" again. Download is by asset ID, so a release published mid-run can't change the run.
2. **Asset selection.** Exactly one asset matching `KittyPatcher*.zip` (case-insensitive). Zero or several means the build fails. Drafts and prereleases are refused.
3. **Digest.** The download must equal GitHub's published `sha256:` digest. If the release publishes no digest, the build stops and asks you to re-run with `approve_unverified_patcher_sha256=<hash>`. It proceeds only if that hash equals the downloaded file.
4. **Package layout.** ZIP paths are checked for safety. Members named `KittyPatcher*.exe` (any folder, any case) are candidates. Byte-identical copies are collapsed (shallowest path wins). Different executables make the selection ambiguous, and the build fails. No v0.1.2 filename or layout is assumed.
5. **Behavior canary.** The selected EXE first patches a synthetic game (`patcher_canary.py`). Required checks (exact `~` and `Replace:/With:` replacement, missing target inserts nothing, untouched text kept, inputs unchanged) must pass. Profile checks compare to intended literal patching: entity text in files with raw `<<macro>>`, and backslashes in replacements. Any finding stops the build before the real patch, unless you re-run with `accept_patcher_behavior_findings=true`, which labels the build *diagnostic*. Multi-match count, `.Mod` loading and CRLF output are recorded.
6. **Record.** `BuildRecord.json` records the release identity, ZIP and EXE SHA256, verification mode, canary result, original game and Mods.zip hashes, candidate and per-mod hashes, log hashes, and the output HTML hash.

`.github/patcher-baselines.json` holds **historical regression baselines** (v0.1.2: ZIP `b105af5a…`, EXE `87205149…`, observed output `070fd80f…` for the current inputs). A match only adds a label. It isn't a pin.

## AI handoff (one file)
- `02 Inspect` uploads `AI-Handoff-Inspect-*` containing `CourseOfTemptation-AI-Handoff.md`, which is **preliminary** because there's no patcher evidence yet, plus `handoff-summary.json`.
- `03 Merge and Patch` uploads `AI-Handoff-Build-*` with patcher selection, behavior-check result, candidate inspection and log excerpts. Both use `if: always()`, so a handoff is produced even when a check stops the run. The check still stops the run; the handoff only reports it.
- Content: instructions for the receiving AI, input and patcher identities, confirmed, suspected and unknown findings, deduplicated non-exact blocks with **candidate** (unverified) game context, short log excerpts, the **complete** merger and its local dependencies labeled by path, reproduction steps, and a missing/untested list.
- Size cap: 600 KB. Evidence is reduced first. Code is never truncated. If essential code doesn't fit, whole files are omitted, listed, and the handoff is marked INCOMPLETE.

### Baseline comparison (optional, manual)
To compare against a previous run: download `handoff-summary.json` from that run's handoff artifact (Actions → run → Artifacts; artifacts expire after 90 days) and commit it as `.github/handoff-baseline.json`. Later handoffs show changes against it. Without that file, the handoff says "No comparison baseline available." There's no automatic cross-run retrieval (deferred).

### Known gap: Linux merge-job failure
If "Merge reviewed original mods" (Linux) fails, the Windows job doesn't run and no build handoff is produced. Give the receiving AI both of these:
1. The Inspect handoff for the same commit (artifact `AI-Handoff-Inspect-<run id>-<attempt>` on the "02 - Inspect" run).
2. The failed merge job's log (`gh run view <run id> --log-failed`, or download it from the job page), plus `Merge-Report-<run id>-<attempt>` if it was uploaded.
