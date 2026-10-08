# Handoff notes for automated assistants

Read first: README.md, docs/PIPELINE.md, docs/BASELINE.md, docs/CHECKPOINTS.md.

Hard rules (from the repository owner):
- Never modify `CourseOfTemptation.html` or `Mods.zip`. Never execute files from `Mods.zip`.
- Work on branches and open PRs. Don't merge or deploy.
- Don't remove or skip failing tests to get a green build.
- Don't silently drop or partially apply mods. Every excluded mod must appear in the compatibility report with a reason.
- Exact matching is the default. Don't add global fuzzy or whitespace matching.
- Keep KittyPatcher v0.1.2 pinned (see PIPELINE.md). Don't replace it without comparison tests and owner approval.
- Builds with a changed mod set must be labeled "compatibility-unverified". Don't claim save compatibility without testing.
- Don't change repository visibility. Don't add external services without approval.
