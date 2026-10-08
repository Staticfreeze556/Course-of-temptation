# Baseline (Phase 1, from `main` @ `dafa50b`)

## CI before this branch
- "02 - Inspect" failed on every recent run. Cause: its packaging step requires `README.md` and `docs/AI-HANDOFF.md`, which didn't exist ([run 37727151143](https://github.com/Staticfreeze556/Course-of-temptation/actions/runs/37727151143)). The inspection itself completed.
- "01 - Prepare" succeeded.
- "03 - Merge" selected the *latest* release without verifying its checksum. Its recursive EXE search would find two EXEs in KittyPatcher v0.1.2 and stop. This failure is inferred from the ZIP contents; I haven't observed it in a run.

## Existing inspector result (golden, `tests/test_inspect_baseline.py`)
`REVIEW REQUIRED`, 0 blockers, 5 warnings, 166 parsed blocks:

| Finding | Blocks |
|---|---|
| One exact original match | 68 |
| Multiple exact original matches | 5 |
| Possible whitespace-only difference | 6 |
| No exact match | 87 |

## Reconciling with the Phase 0 numbers
Phase 0 reported 56 exact / 23 whitespace / 15 chained / 72 missing. That analysis did **not**
strip leading and trailing whitespace from find-text. The repository's scripts (`inspect_mods.py`,
`merge_mods.py`, `check_candidate.py`) do (`old.strip()`). With stripping, 73 blocks match
exactly instead of 56. Which rule KittyPatcher itself uses is **not yet verified**. Its
Python source ships inside the release ZIP (`scripts/KittyPatcher v0.1.2.py`) and will be
read in Phase 2 to settle this.

## Inventory reconciliation
An earlier message said "54 `.mod` files". That was a miscount of ZIP listing lines.
`Mods.zip` has **55 entries = 52 `.mod` files + 2 directory entries + 1 `__MACOSX` metadata file**.
Of the 52 mods:
- 51 use the `find~replace~~` format (166 blocks, inspected).
- 1, `m-mod-cheatplus-v0.1.802.mod`, uses `Replace:`/`With:` (29 blocks) plus `Add Passage:` and `<e>` markers. It is **not inspected** by any current script and is reported as `UNSUPPORTED_FORMAT_NOT_INSPECTED`.
- `KittyDateAnybody.Mod` has an uppercase extension; it's counted and flagged.

## Version mismatch
Mod folder label: `0.5.4g`. Game: `v0.8.4d`. An earlier uploaded game (`v0.8.3j`) matched the
same blocks as 0.8.4d, so the drift predates 0.8.3j.

## KittyPatcher v0.1.2 behavior (read from its bundled source)
Source: `scripts/KittyPatcher v0.1.2.py` inside the pinned release ZIP (SHA256 `fc0ada79…14a6`).
**Not verified:** that the EXE was built from exactly this source. A Windows comparison run is
needed. If the EXE matches the source, these behaviors affect the build today:

| # | Behavior | Effect on this mod pack |
|---|---|---|
| K1 | Strips whitespace around find/replace text | Matches the repo scripts; explains 73, not 56, exact matches |
| K2 | Also parses `Replace:` / `With:` | `m-mod-cheatplus` **is** processed by KittyPatcher, though our scripts don't inspect it |
| K3 | `file.endswith('.mod')` is case-sensitive | `KittyDateAnybody.Mod` is likely **ignored** by KittyPatcher unless renamed earlier |
| K4 | Mod order = `os.walk` filesystem order, not alphabetical | Order isn't guaranteed and can differ between machines |
| K5 | Patches are stored in a dict keyed by find-text | When mods share a target (11 such cases), the last one silently wins |
| K6 | `re.sub` replaces **all** occurrences | The 5 multi-match blocks change every location |
| K7 | Replacement text goes through `re.sub` escape processing | 6 blocks in KittyBuyOtherResidences, KittyGoOverAnybodysHouse and KittyPetNames contain backslashes, which may be altered |
| K8 | Intended whitespace tolerance (`\n` → `\s*`) is a no-op on Python ≥ 3.7, because `re.escape` doesn't produce `\n` | Effectively exact matching |
| K9 | Failed blocks are logged; the rest of the mod still applies | **Partial application** of a mod is normal behavior |

Phase 2 will turn each of these into a test against fixtures. Nothing here was changed in Phase 1.
