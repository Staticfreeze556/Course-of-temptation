# Diagnostic baseline: gameplay and save compatibility unverified

Run [37733625592](https://github.com/Staticfreeze556/Course-of-temptation/actions/runs/37733625592): "03 - Merge and Patch", branch `pipeline-revamp-phase2`, commit `722912ef986f303b0f0579f42f320ec5b579a588` (confirmed as the run's head SHA). `merge.yml` is unchanged since run 37732423437. It has `contents: read`, checks out `github.sha` in both jobs, and has no commit, release, merge or deploy steps.

## Checks
| Check | Result |
|---|---|
| Windows original-HTML fingerprint | `3fd11525…26b4`, which matches Linux (the `.gitattributes` fix worked) |
| Merge-program fingerprint | `21a51880…251e`, which matches the manifest |
| Candidate inspection | REVIEW REQUIRED, 0 blockers, 101 warnings |
| Patcher ZIP SHA256 | passed (`b105af5a…71d6d8`) |
| Patcher EXE SHA256 | passed (`872051498d…752b`) |
| KittyPatcher | ran and exited with code 0 |

## Output
- `CourseOfTemptation.html` SHA256 **`070fd80fb4c56a74cda8dda57416ef855efdd80044e0f902f0449fabe10852de`** (19,364,052 bytes, **CRLF** line endings; the original uses LF).
- The badge text says: "Partially patched diagnostic build: 73 targets applied, 105 failed. Gameplay unverified."
- This is a partially patched build. It doesn't show that the game works.

## What the logs establish
- 184 parsed entries (after the merge step combined 5 shared groups), 178 distinct targets. The patcher log reports **73 made, 105 failed**, and the repo's replay matches those totals.
- The per-mod applied/not-applied counts are in `StructuredPatchReport.md`. 30 mods appear under "Successful" and 35 under "Failed". Many appear in both, because they were partially applied.
- `KittyDateAnybody.Mod` was renamed to `.mod` by `check_candidate.py` and **was loaded**, with 1 target applied.

## Findings and remaining uncertainty
- **cheatplus: only 8 of 29 applied**, although 28 of its targets match the original game exactly. The patcher log shows its find-text with `&quot;` re-escaped to `&amp;quot;` and `&#39;` to `&amp;#39;`, while `&lt;`/`&gt;` stay unchanged. That pattern matches the `escape_twine_tags()` function in the bundled `.py`, which runs when a file contains raw `<<…>>`. cheatplus is the only mod with raw `<<…>>` (1,058 occurrences). In the bundled `.py`, that call is commented out. **So the EXE very likely doesn't match its bundled source.** Not proven, but strongly indicated.
- **Order:** the log order is close to case-insensitive alphabetical, but shared targets interleave it, so the order can't be proven from the logs. Mods were flattened into one folder, sorted by Python, then read by `os.walk` (NTFS order).
- **Duplicate targets:** 6 remain after the merge. The report's "winners" are replay predictions, not observed patcher choices.
- **Replacement text with backslashes (K7):** none of the 6 affected blocks were applied, so this wasn't observed.
- **Multiple-match replacement (K6):** not checked per block in this run.
- **Line endings:** the output is CRLF. Whether that matters to browsers or saves is untested.
