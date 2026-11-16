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
- **Blind.** The grader gets the subject and the inputs in the table. Never the previous score, what you fixed or what you intended.
- **Baseline first.** Before changing something that exists (a restyle, a rewrite, a refactor of a module), grade it as it stands. That number is the anchor for the after.
- **Same inputs both times.** The same pages, viewports and themes before and after. Scores compare only within one rubric version (`code/1`, `ui/1`, `copy/1`).
- **Under 4 points is noise.** Do not report it as progress and do not chase it.
- **Never game it.** No cropped screenshots, no hiding weak parts from the grader, no arguing the case in the brief. Fix the work.

## Loop

The bar: total at least 80 and no dimension under 60.

1. Grade.
2. Under the bar: fix the grader's `Raise` items, then every other finding you agree with, largest first. Rerun the goal contract's checks.
3. Regrade with a new grader. At most two regrades. Stop early at the bar, or when a regrade moves the total by less than 4.
4. Still under the bar: stop polishing. Report the grade and the dimension that holds it down; the PR waits for the user.

In one line each, say why you rejected any finding you did not fix.

## Record

Append one line to `.ult/grades.tsv` (create it with the header on first use):

```
date	commit	subject	rubric	total	dimensions
2026-11-16	a1b2c3d	pricing page	ui/1	84	works 88, clear 85, decided 78, finished 84, copy 85
```

In the PR's Evidence section, one line per rubric, with the baseline when there is one:

```
Grade: code/1 86 (correct 90, proven 80, simple 88, fits 86)
Grade: ui/1 58 -> 84 (works 88, clear 85, decided 78, finished 84, copy 85)
```

## On request

`/ult:grade <target>`: pick the row, grade once, record it, and report the grader's reply as it came. Change nothing unless asked.
