# AGENTS

## High level summary

- Files ending with `.eai` contain JASS AI source code. `common_original.eai` is standard Warcraft 3 AI code, not AMAI code.
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
- Do not modify `common_original.eai`. It contains standard Warcraft 3 AI code, not AMAI logic; make AMAI changes in `common.eai`, `races.eai` or the relevant job source instead.
- Some natives behave differently in AI code so cannot be used e.g anything that spawns threads as AI only allowed a fixed number.
- In timer/deadline polling loops, clamp every computed `Sleep` duration to at least 0.05 seconds, e.g. `Sleep(RMax(0.05, remaining))` or `Sleep(RMax(0.05, RMin(0.2, remaining)))`. A positive fractional remainder can round down without advancing game time, trapping the loop and freezing the entire game. Keep this minimum even on the final wait before a deadline; see `PathingSleep` in `common.eai`.
- Update the CHANGELOG.md when changes are made but should be understandable to my users. Distinguish between internal, dev tools, installer and AI improvements for each change. And keep changes to AMAI code higher up the lists

## JASS runtime safety

These rules apply to AI `.eai` code unless stated otherwise. A runtime error can silently stop one AI thread while the game continues; distinguish this from a whole-game freeze, process crash or multiplayer desync when diagnosing failures.

- Initialize scalar locals before reading them, including handles (`null`). Reading an uninitialized scalar or dividing by zero can terminate the executing thread. Guard variable divisors, including maximum life/mana, counts and distances; choose a meaningful fallback rather than blindly replacing every zero with one.
- Check array indices against the active count and the target runtime's `JASS_MAX_ARRAY_SIZE`; do not hard-code an assumed engine limit. Handle `-1`/missing indices and neutral player IDs before indexing player-only tables. Inventory slots are 0 through 5. Queue capacity checks must include sentinel/scratch slots and occur after acquiring the queue lock; see `TQAddJobEx`.
- Revalidate units, shops, mines and targets after every sleep or deferred job before using their coordinates or issuing orders. A non-null handle does not prove the object still exists. Use `GetUnitTypeId(u) != 0` to check unit existence and `UnitAlive(u)` when a living unit is required; check hero handles before hero-only natives. Do not assume every native safely accepts null or removed objects.
- Respect handle ownership. Destroy only locations/groups created or explicitly transferred to the caller; copy borrowed tracking data when ownership is needed. In AMAI location helpers, `_k` keeps and `_d` destroys the corresponding argument (`DistanceBetweenPoints_kd` destroys its second location). Never pass `home_location`, `army_loc[]` or `town_loc[]` to a consuming argument. Release temporary handles on early returns as well as normal completion, and clear obsolete handle references.
- Every loop must advance, remove an entry or yield on every continuing path. In `FirstOfGroup` loops, remove the current unit even when rejecting it, or explicitly exit. Bound searches and retries, stop on unreadable/end-of-text input, and spread large scans across waits. Polling for movement or construction needs a no-progress timeout; an active order alone does not prove progress. Preserve the minimum sleep rule above.
- AMAI already uses the main AI thread plus five worker threads (pathing, jobs, building, attacks and commands). Reuse the job queue and existing threads; do not add `StartThread` calls or assume a finished thread frees a slot. Keep the main thread alive. Do not introduce `ExecuteFunc`, trigger actions, timer callbacks, `ForGroup`/`ForForce` callbacks or callback filters in AI scripts; enumerate with a null filter and process units explicitly. Map-side Commander code has a different execution context.
- Native string handling differs in the AI runtime. Besides the `I2S`/`R2S` restriction above, do not introduce `SubString` or other string-returning natives without checking AI compatibility; preserve the existing AMAI string workarounds. A native's presence in `common.j` or a successful JASS parse does not establish that it works in AI code.
- For multiplayer code, keep `GetLocalPlayer()` branches limited to supported local presentation changes. Never base unit creation/removal, orders, resources, shared handle allocation or simulation decisions on local-player/camera/selection state. Those changes can desync clients. Test changes to such branches with multiple clients; a single-player run cannot establish synchronization safety.

The [JASS Manual's AI runtime notes](https://jass.sourceforge.net/doc/library.shtml) describe thread termination, thread limits and unsupported callbacks. The [GetLocalPlayer documentation](https://lep.nrw/jassbot/doc/GetLocalPlayer) explains synchronization hazards. Treat historical numeric limits as version-specific; use this repository's target headers and existing regression scenarios for AMAI behavior.

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
- Timing regression tests must cover early wake-ups or rounded sleep durations. Mocks that advance time by exactly the requested delay can hide non-advancing polling loops; see the pathing polling scenarios in `tests/pathing-requests.test.mjs`.
- Do not create random documentation .md files for the tests. This is unnessary with understandable tests.

## PowerShell examples (run from repository root)

Note: these are example commands for a developer. The exact batch script you should run depends on the target platform (REFORGED, ROC, TFT, VER, etc.).

```powershell
# Compile for Reforged (example)
.
\MakeREFORGED.bat

# Build the Electron main (TypeScript compile)
# npm run electron:build
```
