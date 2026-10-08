Course of Temptation Mod Build

Automated build pipeline for combining the supplied Course of Temptation game with its .mod files.

What it does

* Validates the supplied Mods.zip
* Checks mod compatibility against CourseOfTemptation.html
* Reports missing, ambiguous, and conflicting changes
* Merges compatible changes
* Validates the merged candidate
* Runs KittyPatcher v0.1.2
* Produces the final build and diagnostic reports

The goal is to avoid manually editing the game or applying mods one by one.

Use

Place these files in the repository:

* CourseOfTemptation.html
* Mods.zip

Then run the workflows in order:

1. 01 - Prepare Inputs
2. 02 - Inspect Input Compatibility
3. Review the compatibility report.
4. 03 - Merge and Patch Reviewed Mods

The final build is manual-start only. Once started, merging, validation, and patching run automatically when the checks pass.

Important

A successful merge or KittyPatcher run does not guarantee that the game works correctly.

After downloading the final build, launch the game and test the modified features.

For detailed source-migration and AI-assisted merge rules, see docs/AI-HANDOFF.md⁠￼.

Base Version

* Game: CourseOfTemptation.html
* Reported version: v0.8.4d
* Mods: 52 .mod files
* KittyPatcher: v0.1.2
