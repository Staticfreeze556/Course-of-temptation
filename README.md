# Course of Temptation Mod Build

This repository is used to prepare, inspect, merge, and patch the Course of Temptation game with its mod collection.

The goal of this repository is to make the human operator do as little technical work as possible.

You should normally only need to:

1. keep the original game and mod archive in the repository,
2. run the preparation/inspection workflows when needed,
3. give the generated AI diagnostic bundle to an AI when the inspection requires review,
4. replace repository files with the AI's completed files,
5. manually start the final build,
6. download the finished diagnostic game.

You do **not** need to manually edit Python programs or GitHub Actions unless an AI specifically gives you complete replacement files and tells you exactly where they belong.

---

# What this repository does

The build is divided into three stages.

```text
Original game + original Mods.zip
                |
                v
       01 - Prepare Input Mods
                |
                v
       02 - Inspect Compatibility
                |
                v
          AI review if needed
                |
                v
   03 - Merge and Patch Reviewed Mods
                |
                v
       Candidate validation
                |
                v
          KittyPatcher
                |
                v
       Diagnostic game artifact
