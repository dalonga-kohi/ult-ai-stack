---
name: prove
description: Model an algorithm in Lean 4 and prove its key property. Use when a task has a non-trivial algorithm, an invariant that must always hold, or an optimized version of simple logic (scheduling, ranking, pricing, parsing, merging, numeric code). Skip for CRUD, glue and UI.
---

# Prove

Tests check the cases someone thought of. A proof checks all of them. Use it where a wrong answer is costly and the input space is too large to test: the algorithmic core, never the plumbing around it.

A proof here is worth its cost when at least one holds: the property is easy to state and hard to test; you are replacing a simple version with a fast one; the code handles money, ordering, limits or concurrent merges.

## Steps

1. **State the property** in one plain sentence, and the harm if it breaks. Typical shapes:
   - *equivalence*: the fast version returns what the obvious version returns, for every input;
   - *invariant*: the result is always sorted, within bounds, conserves the total, never negative;
   - *algebra*: idempotent, commutative, monotonic, round-trips (`decode (encode x) = x`);
   - *optimality*: no valid answer scores better than the one returned.

2. **Write the spec first**: the simplest definition that is obviously right, however slow. For an optimization this is the naive algorithm. For an invariant it is a predicate.

3. **Model the algorithm** as a pure Lean function that mirrors the real code's structure step for step: same branches, same accumulator, same order. Use the code's own names. Put it in `proofs/` (a Lake project: `lake new proofs` once; pin the toolchain in `lean-toolchain`). Use core Lean only; add Mathlib only when the proof needs real analysis or algebra, because it costs minutes to build.

4. **Test before proving.** `#eval` both functions on a handful of inputs including edge cases, and use `decide` or `by decide` on small bounded instances. A property that is false is found here in seconds, and the counterexample is a finding: report it in the code's terms.

5. **Prove it.** See [EXAMPLE.md](EXAMPLE.md) for the pattern and the tactics that carry most proofs. When induction gets stuck, the statement is too weak: generalize it over the accumulator or loop state. Run `lake build` after each lemma and read only the first error.

6. **Close the gaps.** The proof is done only when `lake build` passes, `rg -n "sorry|admit|axiom " proofs/` finds nothing, and `#print axioms <theorem>` shows no `sorryAx`.

7. **Tie the model to the real code.** The proof covers the model, not the TypeScript, Rust or Go. Bridge it:
   - a property-based test (fast-check, proptest, `testing/quick` or rapid) asserting the same property on the real implementation;
   - a differential test: `#eval` the Lean spec on fixed inputs and assert the real code returns those exact values.

8. **Record it.** In the feature's map file: the property in one sentence, the proof file, the code it covers and the commit it was last checked against. Add `cd proofs && lake build` to the `full` check.

## Rules

- **Never weaken the property to finish the proof.** If you must add an assumption (non-empty input, no overflow, sorted input), state it in the theorem, and make the real code enforce or check it.
- **Bounded integers are not `Nat`.** If the real code can overflow or lose precision, model with `UInt64`, `Int` with explicit bounds, or prove a bound that rules it out. Say which.
- **Timebox.** If a lemma resists after about five distinct attempts, stop. Keep what is proven, cover the rest with the property-based test and a bounded `decide` check, and report exactly which statement is unproven. An honest partial result beats a `sorry`.
- **When the model and the code diverge**, the proof is void. A change to covered code updates the model in the same PR.
- **Say what is proven**: the property, its assumptions, and that it holds for the model. Never claim the system is verified.
