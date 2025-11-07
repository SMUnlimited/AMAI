# AGENTS

## High level summary

- All files ending with `.eai` are AMAI AI source code in its JASS language.
- AI code is compiled to the `Scripts` folder (look there to see generated output used by maps).
- `Common.j` and `Natives.j` are standard Warcraft 3 AI/runtime functions.
- `Blizzard.j` contains standard map functions; `Blizzard.eai` is the AMAI "commander" logic for maps.
- Many build helpers are provided as `.bat` and `.pl` scripts in the project root (for example `MakeREFORGED.bat`, `MakeROC.bat`, `MakeTFT.bat`).

## Important rules & constraints

- Language rule: local variables must always be declared at the start of a function. Any edits to JASS-style code must respect this rule.
- Do not edit generated artifacts in `Scripts/` directly — change source `.eai` files and re-run the project build to regenerate compiled output.
- `Common.j`, `Natives.j` and `Blizzard.j` are built-in war3 code do not make changes to them, they are for reference and building.

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

## PowerShell examples (run from repository root)

Note: these are example commands for a developer. The exact batch script you should run depends on the target platform (REFORGED, ROC, TFT, VER, etc.).

```powershell
# Compile for Reforged (example)
.
\MakeREFORGED.bat

# Build the Electron main (TypeScript compile)
# npm run electron:build
```
