# Course of Temptation Mod Toolkit

## Steps

1. Update `CourseOfTemptation.html` to the latest original game version.

2. Upload a ZIP containing all your original mods to the repository root.
   Upload only one new ZIP at a time. It will automatically be named `Mods.zip`.

3. Wait for preparation and compatibility inspection to finish.
   Download the `Input-Compatibility-Report` artifact and extract it.

4. Copy `docs/AI-HANDOFF.md` and paste it into your AI chat.
   Attach `CompatibilityReport.md` and `InspectionData.json`.
   Provide any additional source files the AI requests.

5. Update the merger using the complete replacement files provided by the AI.

6. Manually run `03 - Merge Reviewed Mods`.
   Review the merge report and copy the Merge Run ID from its summary.

7. Manually run `04 - Inspect Candidate and Patch`.
   Enter the Merge Run ID and the release tag containing KittyPatcher.
   If it stops with candidate warnings, download and review the report
   before rerunning with the warning acknowledgment checked.

8. Download the `Diagnostic-Game` artifact and extract it.
   Review the patch reports and test the generated game separately.

## Important

- Keep `KittyPatcher*.zip` in a repository release.
- Keep backups of the original game and mods.
- Updating the game or mods may require new merger rules.
- Do not replace the original repository HTML with the generated game.
- A successful workflow does not guarantee working gameplay.
