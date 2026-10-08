# Handoff notes for automated assistants

Read first: README.md, docs/PIPELINE.md, docs/BASELINE.md, docs/CHECKPOINTS.md.

Hard rules (from the repository owner):
- Never modify `CourseOfTemptation.html` or `Mods.zip`. Never execute files from `Mods.zip`.
- Work on branches and open PRs. Don't merge or deploy.
- Don't remove or skip failing tests to get a green build.
- Don't silently drop or partially apply mods. Every excluded mod must appear in the compatibility report with a reason.
- Exact matching is the default. Don't add global fuzzy or whitespace matching.
- KittyPatcher comes from the latest GitHub Release, resolved once per build (see PIPELINE.md). Don't hard-code a version. v0.1.2 is a regression baseline only. Don't replace KittyPatcher with another patcher without comparison tests and owner approval.
- Never treat an asset without a published digest as verified. That requires the owner's explicit `approve_unverified_patcher_sha256`.
- Builds with a changed mod set must be labeled "compatibility-unverified". Don't claim save compatibility without testing.
- Don't change repository visibility. Don't add external services without approval.
