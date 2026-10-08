# Course of Temptation Mod Toolkit

Use this repository to inspect your mods, update the merger when needed,
and create a patched copy of the game.

Preparation and inspection run automatically. You manually start the
combined merge-and-patch workflow after reviewing the diagnostic results.

## Before starting

You need:

- The original `CourseOfTemptation.html`.
- One ZIP containing all your original mods.
- A repository release containing `KittyPatcher*.zip`.

Keep backups of your original game and mod archives.

---

## 1. Update the game and check KittyPatcher

### Update the original game

1. Open the repository’s **Code** tab.
2. Select **Add file → Upload files**.
3. Upload the latest original game HTML, named exactly:
   ```text
   CourseOfTemptation.html
   ```
4. Upload it at the repository root, not inside a folder.
5. Select **Commit changes**.

Do not use an already modded game as the original input.

### Check or update KittyPatcher

The build uses the KittyPatcher release tag you enter when starting it.
It does not automatically select the newest patcher.

If the required patcher is already available in a repository release,
keep that release and note its exact tag.

If you need to add a newer patcher:

1. Obtain the intended KittyPatcher ZIP from its trusted source.
2. Open this repository’s **Releases** page.
3. Select **Draft a new release**.
4. Choose a new, descriptive tag for that patcher version.
5. Attach the patcher ZIP. Its filename must match:
   ```text
   KittyPatcher*.zip
   ```
   For example:
   ```text
   KittyPatcher-v0.1.2.zip
   ```
6. Include exactly one matching KittyPatcher ZIP in that release.
7. Publish the release.
8. Note the exact release tag—you will enter it in Step 6.

Keep older patcher releases available so previous builds can be investigated.
Do not upload the patcher ZIP at the repository root; that location is for
the original mod archive.

Using a newer patcher may change patch behavior. Review the resulting reports
rather than assuming it is compatible with the current launcher and diagnostics.


## 2. Upload your mods

1. From the repository’s **Code** tab, select **Add file → Upload files**.
2. Upload one ZIP containing all your original mods.
3. Place it at the repository root—the same location as the game HTML.
4. Select **Commit changes**.

The ZIP can keep its original filename. The preparation action will validate
it and rename it to:

```text
Mods.zip
```

When updating mods, leave the existing `Mods.zip` in place and upload one
differently named replacement ZIP. The action checks the new archive before
replacing the old one.

Upload only one new ZIP at a time. Do not upload KittyPatcher or a merged
candidate ZIP at the repository root.

---

## 3. Download the diagnostic ZIP

1. Open the repository’s **Actions** tab.
2. Wait for `01 - Prepare Input Mods` to finish successfully.
3. Select `02 - Inspect Input Compatibility` from the workflow list.
4. Open the newest inspection run for your uploaded mods.
5. Wait for it to finish.
6. On the run’s summary page, scroll down to **Artifacts**.
7. Click `Input-Compatibility-Report-<number>` to download the ZIP.

The ZIP should contain:

- `AI-HANDOFF.md`
- `CompatibilityReport.md`
- `InspectionData.json`

An inspection failure can still produce a useful report. If the artifact
is missing or incomplete, open the failed job and expand its failed step
to read the error.

If inspection did not start automatically, select
`02 - Inspect Input Compatibility`, click **Run workflow**, select your
working branch, and start it manually.

---

## 4. Give the diagnostics to your AI

Upload the diagnostic ZIP to your AI chat and paste:

> Read AI-HANDOFF.md first, then review CompatibilityReport.md and
> InspectionData.json. Identify what needs changing before merging.
> Provide complete replacement files for any required merger changes.
> Ask for additional source files if the diagnostics are insufficient.

If your AI cannot read ZIP attachments, extract the ZIP and attach the
three files separately.

If requested, also provide:

- Your original `Mods.zip`.
- Your original `CourseOfTemptation.html`.
- The current program files.
- Any relevant logs.

You can also read the
[AI handoff instructions](docs/AI-HANDOFF.md) directly in the repository.

---

## 5. Update the merger

If the AI provides replacement files:

1. Open the repository’s **Code** tab.
2. Open the exact file the AI identifies.
3. Click the pencil icon to edit it.
4. Replace its contents with the complete replacement provided.
5. Select **Commit changes**.
6. Repeat for any other files the AI says must be updated.

The merger program is:

```text
scripts/merge_mods.py
```

Other files may need coordinated changes. Follow the filenames supplied
with each replacement.

If the original mod ZIP or game HTML changes during this review, inspect
the new inputs again before building.

Do not proceed with unresolved blocking findings.

---

## 6. Start the merge-and-patch build

1. Open the **Actions** tab.
2. Select `03 - Merge and Patch Reviewed Mods`.
3. Click **Run workflow**.
4. Select the branch containing your reviewed inputs and updated programs.
5. Check the box confirming that you reviewed the input inspection.
6. Enter the exact release tag containing KittyPatcher.
7. Leave candidate-warning acceptance unchecked for the first build.
8. Click **Run workflow** to start.

### Finding the KittyPatcher release tag

From the repository’s **Code** page, open **Releases** and open the release
containing `KittyPatcher*.zip`.

Use its tag, not its display title. For example, if the tag is `v0.1.2`,
enter `v0.1.2`.

The workflow now:

1. Merges the reviewed original mods.
2. Creates `Merged_Mods.zip`.
3. Checks the candidate and its manifest.
4. Runs KittyPatcher if the checks allow it.
5. Produces reports and a diagnostic game.

You do not need to download and reupload the merged archive between stages.

---

## 7. If candidate warnings stop the build

1. Open the stopped build in **Actions**.
2. Scroll to **Artifacts** on its summary page.
3. Download `Patch-Reports-<run ID>-<attempt>`.
4. Extract it and read `CandidateInspection.md`.
5. Give the report to your AI if repairs or explanations are needed.

After reviewing the warnings, either:

- Update the relevant files and start a new build; or
- Start a new build with candidate-warning acceptance checked if you
  accept diagnostic patching with those warnings.

Warning acceptance cannot bypass blocking findings.

Only reuse a previous warning review when the inputs and relevant programs
have not changed.

---

## 8. Download the game and final reports

After a successful build:

1. Open the completed build in **Actions**.
2. Scroll down to **Artifacts**.
3. Download the artifacts you need:

| Artifact | Contents |
|---|---|
| `Diagnostic-Game-<run ID>-<attempt>` | Generated game HTML |
| `Patch-Reports-<run ID>-<attempt>` | Candidate inspection, structured patch report, and patcher selection details |
| `Raw-Patcher-Logs-<run ID>-<attempt>` | Available raw patcher logs |
| `Merge-Report-<run ID>-<attempt>` | Merge changes and limitations |
| `Merged-Mods-<run ID>-<attempt>` | `Merged_Mods.zip` and its manifest |

Extract the game artifact and test the generated HTML separately.

Review the reports before treating the build as working.

Do not replace the original repository HTML with the generated game.

---

## If something fails

Open the failed run in **Actions**, select the failed job, and expand
the failed step to read its error.

Give your AI:

- The error text.
- Any available report artifacts.
- Raw patcher logs, if available.
- The affected program files when requested.

A failed build may still have useful reports. Some artifacts will not exist
if the workflow stopped before generating them.

---

## For the next game or mod update

Start again from Step 1 or Step 2, depending on what changed.

New inputs may require new merger rules. Do not assume an old merged
candidate or old repair supports the updated files.

## Important

- Keep KittyPatcher in a repository release.
- Keep backups of original inputs.
- Avoid changing inputs while a build is running.
- Merging starts only when you manually run the combined workflow.
- A successful workflow does not guarantee correct mod behavior or gameplay.
