# Course of Temptation Mod Toolkit

## Steps

1. Update `CourseOfTemptation.html` to the latest original game version.

2. Upload a ZIP containing all your original mods to the repository root.
   Upload only one new ZIP at a time. It will automatically be named `Mods.zip`.

3. Wait for preparation and compatibility inspection to finish.
   Download the `Input-Compatibility-Report` artifact and extract it.

4. Give the AI `CompatibilityReport.md` and `InspectionData.json`.
   Ask it to review the findings and provide complete replacement merger
   files where changes are needed. Provide any additional files it requests.

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
