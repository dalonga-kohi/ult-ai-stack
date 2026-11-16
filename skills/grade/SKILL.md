---
name: grade
description: Score work from 1 to 100 against a fixed rubric with a fresh-context grader. Covers code, rendered UI and copy. Use before a PR, after UI work, or to get a baseline for something that exists before improving it.
argument-hint: [what to grade]
---

# Grade

A check says whether the work does the job. A grade says how well, as a number you can compare with the last one. Checks gate and grades rank: a high grade never excuses a red check, and a grade never replaces the goal contract.

## Who grades what

| Subject | Grader | Give it |
| --- | --- | --- |
| Code: a diff, or files as they stand | `ult:reviewer` | the base ref or the paths, the goal contract, the mutant count from `ult:goal` |
| UI: a rendered page or component | `ult:critic` | screenshot paths, the repo's `DESIGN.md`, and the absolute paths of `CRAFT.md`, `SLOP.md` and `COPY.md` |
| Prose: UI text, a README, docs, error messages | `ult:critic` | the files and the absolute path of `COPY.md` |
| A metric (speed, size, accuracy) | the frozen harness in `ult:goal`, never a grader | |

The three rule files are in `../design/` relative to this skill's directory.

Numbers the repo already measures (coverage, Lighthouse, axe, bundle size) go beside the grade in the report. Never fold them into it and never add a tool just to get one.

## Rules

- **The author never grades.** Your own estimate of your work is not a grade and is never reported as one.
- **Blind.** The grader gets the subject and the inputs in the table. Never the previous score, what you intended or your case for the work. A recheck also gets the earlier findings, word for word, and the ref where the fixes start.
- **Baseline first.** Before changing something that exists (a restyle, a rewrite, a refactor of a module), grade it as it stands. That number is the anchor for the after.
- **Same inputs both times.** The same pages, viewports and themes before and after. Scores compare only within one rubric version (`code/2`, `ui/1`, `copy/1`).
- **Under 4 points is noise.** Do not report it as progress and do not chase it.
- **Never game it.** No cropped screenshots, no hiding weak parts from the grader, no arguing the case in the brief. Fix the work.

## Loop

The bar: total at least 80, no dimension under 60, no `BLOCKER` open.

A fresh grader on work it has not seen always has something to say, so regrading until a grader is silent never ends. Each loop below is bounded for that reason. Do not add rounds.

**Code: one review, one recheck.**

1. Review: `ult:reviewer` with the row's inputs. `CLEAN` at the bar ends the loop here.
2. Note the current commit as the fix ref. Fix every `BLOCKER`, then each `SHOULD` you agree with. Run the check a `RISK` names; fix it if it is real. Rerun the goal contract's checks.
3. Recheck: `ult:reviewer` again with the findings as it wrote them and the fix ref. It verifies them and reads only the fix. Its grade is the one you record.
4. A second recheck only when a `BLOCKER` is still open. Never a second full review of the same diff.

**UI and prose: at most two regrades.**

1. Grade with `ult:critic`.
2. Under the bar: fix its `Raise` items, then every other finding you agree with, largest first.
3. Regrade with a new critic. Stop at the bar, or when a regrade moves the total by less than 4.

Still under the bar when the loop ends: stop polishing. Report the grade and what holds it down; the PR waits for the user. In one line each, say why you rejected any finding you did not fix.

## Record

Append one line to `.ult/grades.tsv` (create it with the header on first use):

```
date	commit	subject	rubric	total	dimensions
2026-11-16	a1b2c3d	pricing page	ui/1	84	works 88, clear 85, decided 78, finished 84, copy 85
```

**Findings ledger.** After the code loop, append one line per `BLOCKER` and `SHOULD` to `.ult/findings.tsv` (create it with the header on first use):

```
date	commit	level	kind	where	outcome	note
2026-11-16	a1b2c3d	BLOCKER	empty-input	src/export/csv.ts:42	fixed	no rows -> header-only file crashed the parser
2026-11-16	a1b2c3d	SHOULD	needless-option	src/export/csv.ts:88	rejected	option is in the goal contract
```

`kind` is a short slug for the class of mistake. Read the `kind` column of the file and reuse a slug that fits before coining one. `outcome` is `fixed`, `rejected` or `open`. Then count the kind's rows:

- **Three `fixed` rows of one kind**: the author keeps making this mistake. Encode it as core rule 8 says, a test, a type or a lint rule before a Gotchas line, and say so in the report.
- **Three `rejected` rows of one kind with the same reason**: the reviewer keeps misreading this repo. Add one line to a `## Review` section in the repo's `CLAUDE.md` stating the convention as a fact ("exported options are part of the public contract"). Never a line that tells the reviewer to pass something.

In the PR's Evidence section, one line per rubric, with the baseline when there is one:

```
Grade: code/2 86 (correct 90, proven 80, simple 88, fits 86)
Grade: ui/1 58 -> 84 (works 88, clear 85, decided 78, finished 84, copy 85)
```

## On request

`/ult:grade <target>`: pick the row, grade once, record it, and report the grader's reply as it came. Change nothing unless asked.
