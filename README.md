Course of Temptation Mod Merge Pipeline

This repository automates the process of preparing, inspecting, merging, validating, and patching the Course of Temptation game with the supplied .mod files.

The goal is simple:

The human should have to do as little work as possible.

The human reviews the compatibility evidence, approves the final build when appropriate, and tests the resulting game.

The scripts and workflows do the repetitive work.

1. Repository Inputs

The repository uses two primary inputs:

CourseOfTemptation.html

Mods.zip

The supplied game version is:

v0.8.4d

The supplied mod archive contains 52 .mod files.

Do not manually copy the contents of the .mod files into the game.

The pipeline is designed to process the archive automatically.

2. Preparation

The preparation workflow is:

.github/workflows/prepare.yml

The preparation script is:

scripts/prepare.py

Preparation validates the supplied mod archive and establishes the canonical input.

It checks:

* ZIP integrity
* archive paths
* duplicate paths
* presence of .mod files
* ambiguous incoming ZIP files
* selected input files
* input hashes

If multiple possible incoming mod archives are present, preparation must stop rather than guess which archive should be used.

The original mod archive should be preserved.

3. Compatibility Inspection

The inspection workflow is:

.github/workflows/inspect.yml

The inspection script is:

scripts/inspect_mods.py

Inspection compares the .mod files against the current CourseOfTemptation.html.

The inspection records information including:

* selected commit
* game version
* input hashes
* number of mod files
* parsed replacement entries
* exact matches
* missing targets
* multiple matches
* shared targets
* special patch markers
* warnings
* blockers

The inspection does not execute the mods.

The inspection does not execute KittyPatcher.

The inspection does not prove that the final game works.

4. Review Before Building

The compatibility report must be reviewed before starting the final build.

The human does not need to manually perform every replacement listed in the report.

The report exists to show what the automated process found and identify anything that requires judgment.

Pay particular attention to:

* blockers
* multiple-match replacements
* shared targets
* missing targets
* source-version differences
* special patch formats
* changes that modify existing game logic

If something can be safely resolved from the source, the AI or merge scripts should resolve it.

The human should only be asked to make a decision when the available evidence cannot establish the correct result.

5. Final Build

The final workflow is:

.github/workflows/merge.yml

The final combined build must be started manually.

After the human manually starts the workflow, the remaining stages should proceed automatically when the checks permit:

merge

then

candidate validation

then

KittyPatcher

then

reports and artifacts

The human should not have to manually move files between these stages.

The patch stage must use the exact candidate produced by the merge stage.

6. KittyPatcher

The supplied KittyPatcher version is:

v0.1.2

The final workflow requires the exact KittyPatcher release tag to be supplied.

Do not silently substitute another KittyPatcher version.

7. Source-Aware Merging

The current CourseOfTemptation.html is the base source.

The .mod files may have been created for an older version of the game.

An old replacement must therefore not automatically overwrite an entire newer function or source block.

When the current source has changed, determine what behavior the mod is actually trying to add or change.

Then:

1. Compare the old target with the current source.
2. Identify the intended behavior.
3. Preserve unrelated newer behavior.
4. Migrate the intended behavior into the current source when it can be done safely.
5. Record the result.

If the intended migration cannot be established safely, leave it unresolved and report it.

Do not invent source code simply to make a replacement fit.

8. Exact Matches Are Not Automatically Safe

An exact text match only proves that the text exists.

It does not prove that:

* the match is in the intended location
* the match is unique
* replacing it preserves behavior
* another mod does not modify the same code
* the target belongs to the same game version
* the resulting code is correct

Always consider the surrounding source.

9. Multiple Matches

A target that occurs multiple times must not automatically be replaced everywhere.

For example:

gameday++;

has been identified in multiple contexts, including test-event logic and actual game-clock advancement.

Only the intended occurrence should be modified.

Another example is:

peoplehere: 1, },

which occurs in many event/object contexts.

The surrounding source must determine which occurrence is intended.

10. Shared Targets

Several targets are modified by multiple mods.

Known examples include:

setup.people.valid_phone_contact = function(name) {

this.tattoos = {};

this.age = State.variables.pcage;

this.gender = pdata.species[1];

"Slut": {

//#endregion Clothing Management

<<set $pcage to 18>>

return [...new Set(inclins)]; }

When multiple mods modify the same target, the merge must preserve compatible changes.

One mod must not silently erase another mod’s change.

If two changes conflict, the conflict must be reported.

11. Known Source-Migration Areas

Previous inspection identified differences between the mod targets and the current game source in areas including:

* setup.people.valid_phone_contact
* "Slut" inclination data
* time_to_end
* setup.Relationships.qualified()
* setup.Time.advance_time()
* Gym Shorts definitions
* Swim Trunks definitions
* residence passages
* transport logic
* roommate logic
* pet ownership conditions
* calendar logic
* PC age initialization
* pregnancy logic
* script-boundary markers

These are source-migration areas.

They should not be handled by blindly replacing an entire current function with an older version.

12. Missing Targets

Known missing-target areas have included:

* KittyFacultyContacts
* KittyAddRemoveRoommates
* KittyUncappedSkills
* KittyModifyRelationshipQualify
* KittyAddictUse
* KittyPostApartmentDateUnlimitedRounds
* KittyPregnancyMod
* KittyQuickSexAnywhere
* AdvtimeSafe
* KittyPhoneEvents
* KittyResidentialHallEvents
* KittyBuyOtherResidences
* KittyFreelanceJobs
* KittyDateBJ
* KittyClothing/KittyGymShortsPockets
* KittyClothing/KittySwimTrunksPockets

A missing target means the current source must be examined.

It does not mean that replacement code should be invented.

It does not automatically mean that the mod should be discarded.

13. Special Patch Formats

Some .mod files contain patch instructions that are different from ordinary replacement syntax.

One identified example contains markers such as:

Replace:

With:

Add Passage:

<e>

These files must be processed according to their actual patch format.

They must not be treated as empty simply because the normal replacement parser does not find ordinary replacements.

14. CheatPlus

m-mod-cheatplus-v0.1.802.mod requires special attention.

The normal replacement parser did not identify ordinary replacement entries for this file, while additional patch-format markers were present.

Do not assume that the file contains no changes.

Do not invent normal replacements for it.

Inspect and process its actual patch instructions.

15. Candidate Validation

The candidate produced by the merge stage must be checked before KittyPatcher runs.

These are separate stages:

1. Original compatibility inspection.
2. Merge.
3. Candidate validation.
4. KittyPatcher execution.
5. Runtime and gameplay verification.

A clean inspection does not guarantee a clean candidate.

A clean candidate does not guarantee successful patching.

Successful patching does not guarantee that the game works correctly.

16. Patcher Reporting

scripts/patch_report.py records the patching result.

The report must distinguish between:

* process completion
* patcher exit status
* missing targets
* candidate warnings
* actual modifications
* runtime uncertainty

A message such as:

Mod patching complete.

must not be interpreted as proof that every requested modification was successfully applied.

17. Diagnostic Bundle

scripts/build_diagnostic_bundle.py

The diagnostic bundle should contain the evidence required for another human or AI to understand the build.

It should include:

* AI-HANDOFF.md
* CompatibilityReport.md
* InspectionData.json
* BundleManifest.json
* Mods.zip
* CourseOfTemptation.html
* README.md
* docs/AI-HANDOFF.md
* repository scripts
* repository workflows

The original input files must remain identifiable.

18. AI Instructions

The AI assisting with this repository should:

* read docs/AI-HANDOFF.md
* inspect the current source
* inspect the supplied mod files
* preserve the current game source
* perform safe replacements automatically
* perform source-aware migrations when the intended behavior is clear
* combine compatible changes from multiple mods
* detect conflicts
* avoid global replacements when targets are ambiguous
* never invent missing source
* never silently discard unresolved changes
* clearly identify anything requiring human judgment
* produce the resulting files rather than asking the human to manually reproduce the work

The AI should do the work.

The human should not be turned into the merge engine.

19. Blockers

A blocker must stop the affected stage.

A warning may be acknowledged only when the workflow explicitly permits that acknowledgment.

A warning acknowledgment must never bypass a blocker.

Do not downgrade a blocker simply to make the workflow run.

20. Runtime Verification

Static inspection and automated patching are not gameplay verification.

After the final artifact is produced, the human should:

1. Start the game.
2. Confirm that it loads.
3. Check for immediate JavaScript errors.
4. Test the areas affected by the mods.
5. Confirm that important modified mechanics behave as intended.

The repository must not claim gameplay success unless gameplay was actually tested.

21. Repository Structure

The intended structure is:

.github/workflows/prepare.yml

.github/workflows/inspect.yml

.github/workflows/merge.yml

scripts/prepare.py

scripts/inspect_mods.py

scripts/merge_mods.py

scripts/check_candidate.py

scripts/patch_report.py

scripts/build_diagnostic_bundle.py

scripts/toolkit_common.py

docs/AI-HANDOFF.md

README.md

CourseOfTemptation.html

Mods.zip

22. Final Rule

The repository exists to automate the work.

The human should review the evidence, approve the final build when appropriate, and verify the resulting game.

The AI and scripts should handle everything else that can be established safely from the available source.

Do not make the human manually reproduce work that the repository can perform automatically.

Do not guess simply to avoid asking for a decision.

When the evidence is sufficient, do the work.

When the evidence is insufficient, clearly identify the specific decision that remains.
