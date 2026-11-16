# Worked example: a fast version equals its spec

The real code sums a list with a loop and an accumulator. The property: it returns the same value as the obvious recursive sum, for every list. Checked with Lean 4.35.

```lean
def sumSpec : List Nat → Nat
  | [] => 0
  | x :: xs => x + sumSpec xs

def sumFast (xs : List Nat) : Nat := go xs 0
where
  go : List Nat → Nat → Nat
    | [], acc => acc
    | x :: xs, acc => go xs (acc + x)

theorem sumFast.go_eq (xs : List Nat) (acc : Nat) :
    sumFast.go xs acc = acc + sumSpec xs := by
  induction xs generalizing acc with
  | nil => simp [sumFast.go, sumSpec]
  | cons x xs ih => simp [sumFast.go, sumSpec, ih]; omega

theorem sumFast_eq_spec (xs : List Nat) : sumFast xs = sumSpec xs := by
  simp [sumFast, sumFast.go_eq]

#print axioms sumFast_eq_spec
#eval [[], [1], [3, 4, 5]].map sumFast
```

Expected output: axioms `[propext, Quot.sound]` (no `sorryAx`) and `[0, 1, 12]`.

## The pattern

1. `sumSpec` is the definition nobody argues with.
2. `sumFast.go` mirrors the loop: one argument per loop variable.
3. The direct statement (`go xs 0 = sumSpec xs`) cannot be proven by induction, because the accumulator changes on each step. The lemma states what holds for **every** accumulator: this is the loop invariant. `generalizing acc` makes the induction hypothesis usable.
4. The headline theorem is one line on top of the lemma.

Every loop proof has this shape: find the invariant, state it for an arbitrary state, induct.

## Tactics that carry most proofs

| Goal looks like | Try |
| --- | --- |
| linear arithmetic over `Nat` or `Int`, with `<`, `≤`, `=`, `%`, `/` by literals | `omega` |
| unfold definitions and rewrite with known lemmas | `simp [defs, lemmas]`, then `simp only [...]` once it works |
| concrete, finite, decidable | `decide` |
| recursive function over a list or `Nat` | `induction x generalizing <state> with` |
| function defined by `match` or `if` | `split`, or `cases h : cond` |
| function with a non-structural recursion | `fun_induction f args` |
| many small cases after a split | `all_goals`, `<;> simp_all`, `<;> omega` |
| a mix of equalities, arithmetic and case splits | `grind` |
| need the name of a library lemma | `exact?`, `apply?`, `rw?` |

## Working cheaply

- One lemma at a time. Build, read the first error only, fix, repeat.
- Put `#eval` and small `example ... := by decide` checks beside each definition before attempting the general proof.
- When stuck, write the proof on paper in three lines first. If you cannot, the lemma is false or too weak; look for a counterexample with `#eval` before trying more tactics.
- Termination: prefer structural recursion. If Lean cannot see it, add `termination_by <measure>` and discharge with `omega`.
- Lists: reach for `List.foldl`, `List.take`, `List.drop`, `List.length` lemmas through `simp`; arrays convert with `Array.toList`.
