# AI regression tests

Run the full suite from the repository root with Node.js 24 and Perl available:

```powershell
node --test --test-reporter=spec tests/*.test.mjs tests/build-recovery.mjs tests/repair-control.mjs
```

Tests use Node's built-in test runner and execute production `.eai` functions.
Each gameplay helper creates a fresh game. Keep setup, actions and assertions
visible in the test, and put simulation plumbing in `tests/helpers/`.

- `jass.mjs` contains the shared translator for the JASS subset used by the tests.
  It rejects unsupported statements. Adaptive and repair scenarios pass a type
  map to preserve integer assignment and return rounding; other scenarios retain
  their existing JavaScript arithmetic. This is not a complete JASS interpreter.
- `warcraft-natives.mjs` supplies shared Set-backed group operations, with optional
  tracking for group cleanup checks. Enumeration, unit defaults, orders and other
  scenario-specific behavior stay in each game helper.
- The game helpers expose actions such as `buyItem`, `checkDefense` and
  `checkHarvest`. Add scenarios by using those actions against a fresh game,
  rather than copying the translator or rewriting the production AI logic.

Mocks check source control flow, not Warcraft's pathing, combat, targeting,
hidden-unit enumeration, construction, healing effects or accepted native orders.
The in-game checklists remain necessary:

- [Expansion ownership and harvest groups](../TestingScenarios/expansion-ownership.md)
- [Lumber shortages](../TestingScenarios/harvest-lumber.md)
- [Adaptive strategies](../TestingScenarios/adaptive-strategies.md)

Follow the relevant checklist and build instructions when changing AI behavior.
