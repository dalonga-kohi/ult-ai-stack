---
name: pr
description: Open a pull request with a visual summary, before-and-after evidence and a risk statement, then decide whether it may merge without a human. Use whenever work is ready to leave the branch.
---

# Pull request

The body is a one-minute briefing for a reviewer who has the diff. Template adapted from Matt Pocock's `pr` skill (see CREDITS.md).

## Before opening

- Every check in the goal contract passed on the final commit, and you have the output.
- `git diff <base>...HEAD` contains only what the goal needs. No stray files, no debug output.
- History is a few ordered commits, each one landable.

## Open it

Write the body below to `.ult/pr.md` with the Write tool, then:

```
git push -u origin HEAD
gh pr create --title "<type>(<scope>): <imperative subject>" --body-file .ult/pr.md
```

Title: Conventional Commits (`feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `chore`), no trailing period.

## Body

```markdown
## Summary

<One or two sentences: the problem and the approach.>

<One visual: the smallest view that makes the change clear.>

## Evidence

- **Before:** <failing test, output or screenshot>
- **After:** <passing test, output or screenshot>
- **Grade:** <the lines from `ult:grade`, with the baseline when there is one>

## Merge danger

**Door:** <one-way | two-way>
**Blast radius:** <one word or phrase: who or what this can affect>

<Optional: what could go wrong and how to roll back.>

## Decisions

<Defaults you chose without asking, and issues you opened. Omit if none.>
```

**Summary visual.** Pick one, rarely two:

- logic or an algorithm: pseudocode, as a `diff` if the shape already existed;
- runtime flow: an indented call tree;
- UI structure: a component tree with the state and boundaries that matter;
- file layout or a broad refactor: a shallow file tree with a role per entry;
- interaction between parts: a Mermaid sequence diagram.

Keep only the calls, files and states the reviewer needs. Use a `diff` block when the point is what changed.

**Evidence.** Screenshots for visual changes (before and after, same viewport). Otherwise the exact command and its trimmed output. Name the test that was red and is now green. Evidence is something you observed, never a claim.

**Merge danger.** A two-way door is cheap to revert. A one-way door is not: data migrations, deleted data, published API or schema changes, sent emails, money. State the blast radius honestly; consider consumers, mobile layouts, performance, existing data.

## Merge gate

Enable auto-merge only when **all** of these hold:

- The door is two-way.
- The diff stays inside one feature area, and is docs, tests, an internal refactor with unchanged behavior, or a small contained fix or feature.
- It touches none of: authentication or authorization, payments or billing, database schema or migrations, public API or exported types of a published package, dependency manifests or lockfiles, CI, infrastructure or deploy configuration, secrets or environment handling.
- The repo has CI checks on pull requests, and the goal contract's checks are covered by them or passed locally with output in the PR.
- The reviewer agent returned no BLOCKER, and every grade meets the bar in `ult:grade`.

Then:

```bash
gh pr merge --auto --squash --delete-branch
```

`--auto` merges only after required checks pass. If CI runs but branch protection marks no check as required, wait for `gh pr checks --watch` to exit green and then merge without `--auto`. If any check fails, read the failure, fix it on the branch and let it rerun; never bypass it.

If the gate does not hold, leave the PR open, and say in the final report which condition failed. When in doubt, the gate does not hold.
