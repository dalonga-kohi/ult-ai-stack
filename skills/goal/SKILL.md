---
name: goal
description: Write a goal contract, the verifiable target for a task, before changing code. Use at the start of any implementation, bug fix, refactor or performance work.
---

# Goal contract

The contract is your reward signal. It says what done looks like in a form a command can decide, so progress is measured and not felt.

## Write it

```
Goal: <one sentence, the outcome a user or caller observes>
Checks:
- `<command>` -> <exact observation that means success>
- `<command>` -> <...>
Guard: `<command>` stays green        (the regression suite)
Out of scope: <what this task will not touch>
```

Keep it in your reply and copy it into the PR's Evidence section at the end.

## Pick checks, strongest first

1. **A failing test at the public interface** that states the behavior. Best for logic.
2. **A script that drives the real thing**: a CLI invocation, an HTTP call, a browser run with a screenshot. Required for anything a user sees or touches.
3. **A measured number with a threshold**: latency, bundle size, allocations, accuracy. Read [HILLCLIMB.md](HILLCLIMB.md) before optimizing a metric.
4. **Typecheck, lint, build.** These guard; they never prove a feature works on their own.

## Rules

- **Watch each check fail first.** A check you have never seen red proves nothing. For a bug, the check reproduces the bug before the fix. If it is green before you start, it is the wrong check.
- **Expected values come from an independent source**: a worked example, the spec, a known-good literal. Never from running the code you are about to verify.
- **One command per check, cheap to rerun.** If it takes minutes, add a narrower one for the loop and keep the slow one for the end.
- **The contract is frozen once work starts.** If a check turns out wrong, say so, fix the check in its own commit and explain it in the PR. Never bend a check toward the code.
- **No check possible** means the goal is not understood yet. Sharpen the goal or ask.

## Use it

After every change, run the narrowest check that covers it. Green: commit and move on. Red: read the failure, form one hypothesis, change one thing. Revert a change that did not help; do not leave it in as "might be useful".

## Prove the checks bite

When the work is finished and committed, break it on purpose. Pick up to three changed lines that carry behavior (a condition, a boundary, a call with an effect; one line for small work). For each: break the line, run the narrowest check, then `git restore <file>`.

A mutant that leaves the checks green marks a missing test. Write the test, watch it catch the mutant, commit it. End with `git status` clean and record `Mutants: 3/3 caught` next to the contract: the reviewer scores `proven` from it.
