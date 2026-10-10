# AGENTS

## High level summary

- All files ending with `.eai` are AMAI AI source code in its JASS language.
- AI code is compiled to the `Scripts` folder (look there to see generated output used by maps).
- `Common.j` and `Natives.j` are standard Warcraft 3 AI/runtime functions.
- `Blizzard.j` contains standard map functions; `Blizzard.eai` is the AMAI "commander" logic for maps.
- Many build helpers are provided as `.bat` and `.pl` scripts in the project root (for example `MakeREFORGED.bat`, `MakeROC.bat`, `MakeTFT.bat`).

## Important rules & constraints

- Language rule: local variables must always be declared at the start of a function. Any edits to JASS-style code must respect this rule.
- Function order is important, functions cannot be called unless it is imported or available higher up in the file.
- Do not use `R2S` or `I2S` in AI code. Use AMAI's `Real2Str` and `Int2Str` helpers instead; they work around native string-conversion issues in the AI runtime.
- Do not edit generated artifacts in `Scripts/` directly — change source `.eai` files and re-run the project build to regenerate compiled output.
- `Common.j`, `Natives.j` and `Blizzard.j` are built-in war3 code do not make changes to them, they are for reference to hardcoded functions and building.
- Some natives behave differently in AI code so cannot be used e.g anything that spawns threads as AI only allowed a fixed number.
- Update the CHANGELOG.md when changes are made but should be understandable to my users. Distinguish between internal, dev tools, installer and AI improvements for each change. And keep changes to AMAI code higher up the lists

## Useful file locations

- AI source code: `*.eai` files (mostly under the top-level `AMAI/` folder).
- Compiled/packaged AI used by maps: `Scripts/` folder (after running the build scripts).
- Build helpers and packaging scripts: top-level `.bat` files (e.g., `MakeREFORGED.bat`) and Perl scripts like `InstallToDir.pl`.
- Electron app and UI: `Electron/` (contains Angular + Electron tooling).

## Quick workflow for making an AI change

1. Find the source `.eai` file(s) to change. Use filename search for the feature you need to edit.
2. Make minimal, well-scoped changes. Keep local variable declarations at the head of functions.
3. Run the relevant build script to compile AI code into `Scripts/` (PowerShell example below).
4. Verify compiled output in `Scripts/` and run a map/test to exercise the change.
5. Add or update tests or small reproducible map scenarios when possible.

## Test readability

- Follow `tests/harvest-startup.test.mjs` for AI regression tests: use Node's built-in `describe` and `it` with names that explain the setup, action, and expected behavior.
- Start each test with a fresh game. Separate setup, action, and assertions with blank lines; avoid long scripts that mutate shared state across several scenarios.
- Keep JASS translation, Warcraft native mocks, and game setup in `tests/helpers/`. The test file should read as gameplay scenarios, without requiring readers to understand the harness first.
- Use plain action names such as `buyItem`, `sendHome`, and `checkHero`. Keep meaningful setup and expected outcomes visible in each test; avoid generic abstractions or dense scenario matrices.
- Preserve coverage of the actual source functions. Do not replace production logic with a hand-written version of the behavior under test.
- Include the exact run command and keep the matching in-game scenario document current. Automated checks should state where mocks cannot verify Warcraft behavior.

## PowerShell examples (run from repository root)

Note: these are example commands for a developer. The exact batch script you should run depends on the target platform (REFORGED, ROC, TFT, VER, etc.).

```powershell
# Compile for Reforged (example)
.
\MakeREFORGED.bat

# Build the Electron main (TypeScript compile)
# npm run electron:build
```
