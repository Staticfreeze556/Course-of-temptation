# Diagnostic baseline: gameplay and save compatibility unverified

Run: [37732423437](https://github.com/Staticfreeze556/Course-of-temptation/actions/runs/37732423437). "03 - Merge and Patch", `workflow_dispatch`, branch `pipeline-revamp`, commit `c2eb93384527b9b97bc3cc632c9f578ff484641e`. Both review inputs were set to `true`, with owner approval for this one diagnostic run.

Pre-run checks: the workflow has `permissions: contents: read`, both jobs check out `github.sha` (verified as `c2eb933`), and its only outputs are `actions/upload-artifact` steps. It contains no commit, push, release, merge or deploy steps.

## Result: stopped before KittyPatcher ran
| Job / step | Result |
|---|---|
| Merge reviewed original mods | success: 52 mods retained, 5 shared-target groups merged into `KittyPregnancyMod.mod`, 5 files changed in the **candidate copy**, 6 shared targets remaining. Candidate SHA256 `ab09cfbd…a87d`. |
| Verify manifest and inspect candidate (Windows) | **BLOCKED**, 2 blockers |
| Download pinned KittyPatcher / ZIP checksum | skipped (not reached) |
| Run KittyPatcher / EXE checksum | skipped (not reached) |
| Diagnostic game artifact | not produced, so there is no generated-HTML SHA256 |

Blockers in `CandidateInspection.md`:
1. "Original HTML does not match the merge input." The Windows checkout hashed the HTML as `a9f780da…be7`, while Linux hashed `3fd11525…26b4`.
2. "Merge program hash does not match the candidate manifest." `merge_mods.py` hashed `21a51880…251e` on Linux.

Root cause (confirmed locally): the repo had no `.gitattributes`, so the Windows runner's checkout converted LF to CRLF. Converting the original HTML's LF to CRLF gives exactly `a9f780da0246…`. This is a pre-existing pipeline defect, not a mod problem. Phase 2 adds `.gitattributes` with `* -text`.

## What the logs can and can't show
- Patcher-level processed/skipped/failed blocks, ordering, cheatplus handling and replacement-text changes: **not observable**, because KittyPatcher never ran. The raw-log upload step ran but found no patcher logs.
- Duplicate targets: the merge step **observed** 11 shared targets. It merged 5 groups and reported 6 as remaining.
- Originals: the repo's `CourseOfTemptation.html` and `Mods.zip` are unchanged (`tests/test_originals.py`). The workflow has read-only permissions and the branch head is still `c2eb933` after the run.

Full logs and artifacts are kept outside the repository (run log, MergeReport.md, CandidateInspection.md, MergeManifest.json, Merged_Mods.zip).
