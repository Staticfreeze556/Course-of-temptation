# Course-of-temptation: mod build pipeline

This repository builds a modded copy of **Course of Temptation** (a SugarCube 2.36.1 game)
from two original, never-modified inputs:

| File | What it is | SHA256 |
|---|---|---|
| `CourseOfTemptation.html` | Game, version `v0.8.4d` | `3fd11525…26b4` |
| `Mods.zip` | 52 `.mod` files in `Mods -version 0.5.4g/` | `06c6ddd7…cacc6` |

> **Known limitation:** the mod pack is labeled for game 0.5.4g. Against the
> 0.8.4d game, most mods don't apply as written. See
> [docs/BASELINE.md](docs/BASELINE.md).

## Pipeline

1. **01 - Prepare Input Mods** (`prepare.yml`): runs on ZIP upload. Validates the archive and normalizes its name to `Mods.zip`.
2. **02 - Inspect Input Compatibility** (`inspect.yml`): static compatibility report. Doesn't modify anything.
3. **03 - Merge and Patch Reviewed Mods** (`merge.yml`): manual start only. Merges mods, then runs the **latest released** KittyPatcher (resolved once, digest-verified, canary-checked) on Windows.
4. **Tests** (`tests.yml`): `pytest` on every push and PR.

## Running locally

```
pip install pytest pyyaml
python -m pytest -q tests
python tools/inventory.py          # Mods.zip inventory (read-only)
```

Docs: [PIPELINE](docs/PIPELINE.md) · [BASELINE](docs/BASELINE.md) · [INVENTORY](docs/INVENTORY.md) · [AI-HANDOFF](docs/AI-HANDOFF.md) · [CHECKPOINTS](docs/CHECKPOINTS.md)
