# Pipeline details

## Ground rules
- `CourseOfTemptation.html` and `Mods.zip` are never modified. `tests/test_originals.py` enforces their hashes.
- Nothing from `Mods.zip` is executed. Mods are read as text.
- Mods in formats the pipeline can't interpret are reported as `UNSUPPORTED_FORMAT_NOT_INSPECTED`, never as inspected (`tools/inventory.py`).
- Failing tests are not removed or skipped to make CI green.

## Patcher pinning
`merge.yml` downloads exactly:

| Field | Value |
|---|---|
| Release tag | `kitty-patcher` |
| Asset | `KittyPatcher.v0.1.2.zip` |
| ZIP SHA256 | `b105af5a3b73e4e4387d20e3eb67013f25a4a0b13a58a2b9a820a7a03b71d6d8` (matches GitHub's published asset digest) |
| EXE | `KittyPatcher v0.1.2.exe` (ZIP root) |
| EXE SHA256 | `872051498db367f6ce74060708f38ae8703de280f0365e967f9e347f58ee752b` |

The job stops before running anything if either hash differs. The release ZIP contains the
EXE twice (root and `scripts/`, byte-identical). The old recursive search found both and
failed with "Expected one KittyPatcher EXE". The pinned step uses the root copy explicitly.

To update the patcher: publish the new release, compute both hashes, update `merge.yml`
and `tests/conftest.py` in the same reviewed commit.
