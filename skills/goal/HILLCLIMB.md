# Hillclimb: improving one metric

Use when the goal is a number (faster, smaller, more accurate) and not a behavior.

1. **Fix the metric.** One number, the direction that is better, and a stop rule that pairs a target with a minimum number of attempts ("30% faster than baseline and at least 5 attempts"), so one lucky run cannot end the work.
2. **Build the harness, then freeze it.** One command prints the metric on a realistic workload. Take the median of several runs. Prove it is sensitive: make the code deliberately worse and confirm the number moves. Record the baseline and a green guard run before any change.
3. **Keep a log** outside the tree (`.ult/hillclimb.tsv`, gitignored): attempt, hypothesis, before, after, kept or reverted. Read it before each attempt.
4. **One hypothesis per attempt.** Name the mechanism ("this allocates per row; reuse the buffer"), not a hope ("try caching"). Order of attack: do less work, do it once, do it in bulk, do it later, then micro-tune.
5. **Measure, then decide.** Keep the change only if the metric moves past run-to-run noise and the guard stays green. Otherwise revert all of it. One commit per kept change.
6. **On a plateau**, change category: algorithm, data layout, I/O pattern. If the hot path is an algorithm, model it with `ult:prove` and prove the fast version equals the simple one before trusting it.
7. **Stop** when the rule is met or the remaining ideas cost more than they return. Never relax the target to meet it. Correctness and simplicity outrank the number: revert a win that breaks behavior, keep a simplification that holds the number.

Report: baseline to final with the percent change, attempts kept and reverted, each kept change in one line, the next idea you would try.
