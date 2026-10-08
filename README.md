# Course of Temptation Mod Toolkit

## Steps

1. Update `CourseOfTemptation.html` to the latest original game version.

2. Upload a ZIP containing all your original mods to the repository root.
   Upload only one new ZIP at a time. It will automatically be named `Mods.zip`.

3. Download the diagnostic ZIP:
   - Open the repository’s **Actions** tab.
   - Wait for `01 - Prepare Input Mods` to finish successfully.
   - Select `02 - Inspect Input Compatibility` from the workflow list.
   - Open the newest run for your uploaded mods and wait for it to finish.
   - On that run’s summary page, scroll down to **Artifacts**.
   - Click `Input-Compatibility-Report-<number>` to download the ZIP.

   The ZIP should contain:
   - `AI-HANDOFF.md`
   - `CompatibilityReport.md`
   - `InspectionData.json`

   An inspection failure can still produce a useful diagnostic ZIP.
   If the artifact is missing or does not contain all three files,
   check the failed step’s log before continuing.


4. Upload that ZIP to your AI and say:
   “Read AI-HANDOFF.md first, then review the diagnostic files and provide
   complete replacement merger files for any required changes.”

   If your AI cannot read ZIP attachments, extract the ZIP and attach
   the three files inside. Provide any additional source files it requests.

5. Update the merger using the replacement files provided by the AI.

6. Manually start `03 - Merge and Patch Reviewed Mods`.
   Confirm that you reviewed the inspection and enter the exact release
   tag containing KittyPatcher.
   Leave candidate-warning acceptance unchecked initially.

7. The workflow creates `Merged_Mods.zip`, checks it, and then patches
   a copy of the original game automatically.

8. If candidate warnings stop the workflow, download the `Patch-Reports`
   artifact and read `CandidateInspection.md`.
   Review the findings before starting a new build with warning acceptance
   enabled. Blocking findings cannot be bypassed.

9. After a successful build, download and extract the `Diagnostic-Game`
   artifact. Review the patch reports and test the generated game separately.

## Important

- Keep `KittyPatcher*.zip` in a repository release.
- Keep backups of the original game and mods.
- Updating the game or mods may require new merger rules.
- Merging starts only when you manually run the combined workflow.
- You do not need to download and reupload the merged archive for patching.
- Do not replace the original repository HTML with the generated game.
- A successful workflow does not guarantee working gameplay.
