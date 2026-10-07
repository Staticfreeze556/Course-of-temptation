# Course of Temptation Mod Toolkit

Prepare, inspect, merge, and patch Course of Temptation mods using separate, reviewable stages.

## Important files

| File | Purpose |
|---|---|
| `CourseOfTemptation.html` | Untouched original game at the repository root |
| `Mods.zip` | Untouched original mod archive after preparation |
| `Merged_Mods.zip` | Generated candidate inside the merge artifact |
| `docs/AI-HANDOFF.md` | Technical context and instructions for an AI assistant |

Keep the KittyPatcher ZIP in a repository release, not at the repository root.

The merger and patcher never start automatically.

---

## Quick start

### 1. Upload original mods

Upload one original mod ZIP at the repository root.

It can have any filename. Leave the existing `Mods.zip` in place when uploading a differently named replacement.

The `01 - Prepare Input Mods` action:

- Checks ZIP integrity and archive paths.
- Checks that `.mod` files exist.
- Renames the incoming archive to `Mods.zip`.
- Replaces an existing `Mods.zip` only after validation.
- Commits the filename normalization.

Upload only one incoming ZIP at a time.

If you upload directly as `Mods.zip`, your upload commit replaces the previous file before validation. Use the archive's original, different filename if you want validation before replacement.

### 2. Review compatibility inspection

After successful preparation, `02 - Inspect Input Compatibility` runs automatically.

It can also be started manually.

Download:

```text
Input-Compatibility-Report-<run number>
```

This contains:

```text
CompatibilityReport.md
InspectionData.json
```

Results:

| Status | Meaning |
|---|---|
| `BLOCKED` | Resolve blocking findings before merging |
| `REVIEW REQUIRED` | Review warnings and update merger rules where needed |
| `STATIC CHECKS PASSED` | These checks found no issue; compatibility is not certified |

A green action can still report `REVIEW REQUIRED`.

The JSON contains full parsed search targets and replacement bodies. The readable report contains shortened previews.

### 3. Update the merger if necessary

For new mod releases:

1. Review the inspection findings.
2. Give an AI assistant the report and JSON.
3. Provide affected source files when needed.
4. Update `scripts/merge_mods.py` with the reviewed repair.
5. Rerun inspection if the original ZIP or HTML changes.

Do not automatically reuse old merge rules for new inputs.

Do not change expected versions or counts merely to bypass failures.

### 4. Manually merge

Open Actions and select:

```text
03 - Merge Reviewed Mods
```

Select Run workflow and check the inspection-review acknowledgment.

The merger uses:

```text
Mods.zip
CourseOfTemptation.html
```

It produces two artifacts:

```text
Merged-Mods-<run ID>
Merge-Report-<run ID>
```

The candidate artifact contains:

```text
Merged_Mods.zip
MergeManifest.json
```

The report artifact contains:

```text
MergeReport.md
```

Review the merge report and record the numeric Merge Run ID shown in the summary.

You do not need to upload the merged archive into the repository.

### 5. Manually inspect and patch the candidate

Open Actions and select:

```text
04 - Inspect Candidate and Patch
```

Enter:

- Merge Run ID from the selected successful merger.
- Exact release tag containing `KittyPatcher*.zip`.
- Leave Accept static warnings unchecked initially.

The action downloads that merge run's candidate artifact and checks:

- Selected workflow and successful run.
- Manifest run ID, repository, and commit.
- Candidate archive hash.
- Current original archive and HTML hashes.
- Candidate archive integrity and paths.
- Readable mod count.
- Basic merged-target structure.
- Missing, multiple, and shared target warnings.

If warnings are found, the action stops before patching and uploads an inspection report.

Review the warnings. If appropriate, rerun with the same inputs and warning acknowledgment enabled.

Blocking findings cannot be bypassed by that acknowledgment.

### 6. Review results and test separately

Patch artifacts:

```text
Patch-Reports-<run ID>
Diagnostic-Game-<run ID>
Raw-Patcher-Logs-<run ID>
```

Reports may include:

```text
CandidateInspection.md
StructuredPatchReport.md
PatcherSelection.md
```

Only a successful patch workflow uploads the diagnostic game.

Review the patch report and raw logs before gameplay testing.

Never replace the original repository HTML with the generated diagnostic game.

---

## When inputs change

A candidate belongs to the exact original ZIP and HTML used to create it.

If either original changes, create a new candidate.

The patch action rejects candidates whose input hashes do not match the current checkout.

A change to merger code does not itself invalidate an older candidate's input hashes. Select the new merge run when you want the updated rules applied.

Avoid uploading another mod release while preparing, inspecting, or merging the current one. Each stage reports its inspected input hashes; compare them when reviewing results.

---

## Current merge rules

Ruleset:

```text
five-shared-groups-v1
```

Current assumptions:

```text
Game version: v0.8.4d
Mod count: 52
```

The merger combines five known shared target groups involving:

- `KittyBuyOtherResidences.mod`
- `KittyFollowers.mod`
- `KittyGoOverAnybodysHouse.mod`
- `KittyPetNames.mod`
- `KittyPregnancyMod.mod`

This is a targeted ruleset, not a general-purpose merger.

It does not repair all rent, residence, calendar, or Cheatplus issues.

Read the generated merge report for the explicit changes and limitations.

---

## Programs and workflows

| Program | Responsibility |
|---|---|
| `scripts/prepare.py` | Validate and normalize the original ZIP |
| `scripts/inspect_mods.py` | Inspect original mods and HTML |
| `scripts/merge_mods.py` | Apply reviewed merge rules and generate a manifest |
| `scripts/check_candidate.py` | Validate the selected candidate before patching |
| `scripts/patch_report.py` | Generate a diagnostic patch replay report |

| Workflow | Trigger |
|---|---|
| `.github/workflows/prepare.yml` | ZIP upload or manual start |
| `.github/workflows/inspect.yml` | Successful preparation, selected source changes, or manual start |
| `.github/workflows/merge.yml` | Manual only |
| `.github/workflows/patch.yml` | Manual only |

Preparation is the only workflow configured to commit changes back to the repository.

Other stages generate runner files and downloadable artifacts.

---

## Troubleshooting

### Preparation found several ZIPs

Leave only one incoming ZIP at the repository root, plus the existing canonical `Mods.zip`.

Do not upload KittyPatcher or generated candidate ZIPs there.

### Inspection did not start automatically

Ensure the inspection workflow exists on the default branch.

Its configured predecessor name must match:

```text
01 - Prepare Input Mods
```

If preparation completed before inspection was added, manually run inspection.

### Merge acknowledgment was not checked

Review the current inspection and rerun the merger with the acknowledgment checked.

The acknowledgment does not automatically verify the report.

### Candidate is stale

Current `Mods.zip` or original HTML differs from the merge input.

Review the current inspection and perform a new merge.

### Candidate artifact cannot be downloaded

Check that:

- The Run ID is correct.
- The selected merge succeeded.
- The candidate artifact still exists.
- The run belongs to this repository.

If the artifact is unavailable, rerun the reviewed merger.

### Candidate preflight stopped with warnings

Download `CandidateInspection.md`.

Review it before enabling the warning acknowledgment.

### KittyPatcher download failed

Enter the exact release tag, not the release title.

The selected release must contain exactly one asset matching:

```text
KittyPatcher*.zip
```

### Replay and patcher totals differ

Treat this as a diagnostic discrepancy, not automatic proof of either result.

Provide the structured report and raw patcher logs for investigation.

---

## What success does not prove

These are separate outcomes:

1. Original ZIP passed preparation.
2. Static inspection completed.
3. Configured merge prerequisites passed.
4. Candidate ZIP was created.
5. Patcher reported replacements.
6. Diagnostic replay produced matching totals.
7. Gameplay was tested.

One does not automatically establish the next.

The pipeline does not fully validate JavaScript or SugarCube syntax.

Keep separate backups of original releases and the original HTML.
