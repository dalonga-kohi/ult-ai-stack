---
name: plan
description: Find the shortest path from the current code to a goal before building. Reuse, cut, choose a route, slice vertically, and send work too big for one pull request to ult:grill-me. Use before any non-trivial implementation, or alone to plan without coding.
argument-hint: <what to plan>
---

# Plan

A plan is the shortest sequence of verified steps from the code as it is to the outcome. Planning time goes into removing work, not describing it.

## Steps

1. **Outcome.** One sentence a user or caller would say when it works. With a goal contract, this is its `Goal` line.

2. **Reuse.** Find what already does part of the job: a helper, the pattern a sibling feature uses, a library already in the manifest. Read the map, then search. The shortest path extends an existing path; it rarely builds beside one. Write down what you will reuse and where it is.

3. **Cut.** List what the request implies, then strike everything the outcome does not need now: options, configuration, generality, a second case nobody asked for. A struck item with real value goes on the `Later` line. It does not go into the code.

4. **Route.** When more than one approach is plausible, write up to three, one line each, and choose by, in order: fewest new concepts for the next reader, least new code, easiest to undo. When reading cannot decide, spike the riskiest part on a throwaway branch, keep what you learned and discard the code.

5. **Slices.** Each slice goes through every layer it needs and ends in a passing check and a commit.
   - The first slice is the thinnest path through the real entry point, end to end, even if it handles one case.
   - Next comes the slice most likely to prove the plan wrong. Finding that out late costs the most.
   - Polish and rare cases come last, where they can be cut.

6. **Size.** The work is **Large** when any of these is true:
   - it holds more than one outcome a user could receive separately;
   - it needs more than 6 slices;
   - it touches more than 2 feature areas of the map;
   - it will change more than about 400 lines, tests excluded.

## Large work goes to issues, never into one go

This holds even when the request says to do all of it. One oversized change is reviewed badly, verified badly and reverted whole, and the session that builds it runs out of context before the end. Stop planning. The work goes through `ult:grill-me`, which settles the open decisions with the user and files each part as a sub-issue that fits one fresh session.

## Write the plan

```
Outcome: <one sentence>
Reuse: <path:symbol, what it gives>
Cut: <what was struck>
Route: <chosen> over <rejected>: <reason>          (only when there was a choice)
Slices:
1. <slice> -> `<check that passes>`
2. <...>
Size: <Small | Standard>
Later: <struck items worth keeping>
```

At most 16 lines. A plan that needs more is hiding a second feature: return to step 6.

## On request

`/ult:plan <what>`: produce the plan and change no code. End with the `/ult:ship` command that starts it. When the work is Large, write no plan: say which size test it fails and give `/ult:grill-me <what>` instead.
