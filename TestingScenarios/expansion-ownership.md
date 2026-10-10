# Expansion ownership regression scenarios

Run from the repository root:

```powershell
node --test --test-reporter=spec TestingScenarios/expansion-ownership.test.mjs
node TestingScenarios/expansion-retries.test.mjs
.\MakeREFORGED.bat 1
```

The automated scenarios execute the source claim, duplicate cleanup, build
callback and harvest mine selection functions with mocked Warcraft natives.
They check own versus allied ownership, existing mines versus movable halls,
duplicate foundations, lingering dead mine buildings, and hidden deposits.
They cannot establish Warcraft's mine replacement timing, unit enumeration,
entangling range, accepted harvest orders, construction placement or pathing.
Verify the following in Warcraft III using the rebuilt scripts.

## Undead hall and Haunted Gold Mine

1. Start a fresh Undead game and expand to a cleared neutral mine.
2. Build a Necropolis beside the mine before haunting it. Also test rebuilding
   the Haunted Gold Mine while retaining the Necropolis.
3. Verify the mine is haunted, construction finishes and acolytes gather gold.
   The Necropolis must not cause the mine construction to be stopped or cancelled.
4. In a separate game, let an ally haunt the site first. Verify the AI respects
   the allied mine. Genuine duplicate Haunted Gold Mine foundations should
   still retain only one winner.

## Night Elf owned mine and later expansions

1. Start a fresh Night Elf game on Emerald Gardens. Keep clear buildable space
   beside an existing Entangled Gold Mine.
2. Let the AI request its next expansion. Verify it chooses another available
   neutral mine and does not build a second Tree of Life beside its owned mine.
3. Repeat across several starting positions and expansion timings. Verify
   subsequent expansions still proceed after entangling the first expansion.
4. In a separate game, leave a completed Tree of Life without an active mine
   near a neutral deposit. Verify it can still relocate and entangle the deposit.

## Human and Orc reclaiming formerly captured mines

1. Start a fresh Orc game with an Undead opponent. Destroy the opponent's
   Haunted Gold Mine and its nearby hall, leaving gold in the deposit.
2. Build a Great Hall at the released mine. Verify peons gather gold after the
   underlying neutral deposit becomes exposed.
3. Repeat in fresh games with an Entangled Gold Mine and with Human peasants.
4. Observe the transition while the captured mine building disappears: workers
   must not be assigned to its corpse or to the hidden underlying deposit.
   They should be assigned once the exposed neutral mine is available.
