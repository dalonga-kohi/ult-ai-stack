---
name: ship
description: Take a feature or fix from request or issue to pull request, end to end. Use when the user asks to implement, build, add or fix something, or to do an issue, and wants it shipped.
argument-hint: <what to build | #issue>
---

# Ship

You own the outcome from request to PR. Do not stop to ask for approval between steps. Stop only at the conditions listed at the end.

## Size the work first

- **Small**: one module, the change is obvious, about 30 lines or fewer. Skip steps 2 and 4. Still write the goal and still verify.
- **Standard**: fits one pull request. Run every step.
- **Large**: any size test in `ult:plan` is true. Build nothing, even when asked to build it all. Run `ult:grill-me` with the request: it ends in issues, and each one is shipped in its own session. If the task is already a sub-issue, its split was too coarse. Do not interview again: split it into sub-issues of the same parent with the filing steps of `ult:grill-me` (its ISSUES.md), close it as replaced by them, and stop.

## Steps

1. **Preflight.** If `.ult/task.md` exists, this is a resumed task: read it and continue from the first unticked slice. Otherwise confirm the working tree is clean and create a branch from the default branch (`feat/<slug>` or `fix/<slug>`; from an issue, `feat/<number>-<slug>`). Read the `## Checks` section of the repo's `CLAUDE.md`. If it is missing, run the `ult:setup` skill first.

   **From an issue** (`#13` or its URL): read it with `gh issue view 13 --json title,body,state`, and read the parent named on its first line the same way. If any issue on its `Blocked by` line is still open, stop and name it. If `Needs you` is not `no`, ask for that before anything else. The issue's `Outcome`, `Context` and `Done when` are the request. The decisions in it are made; do not reopen them unless the code makes one impossible, and then stop and say which one.

2. **Understand.** Read `docs/map/README.md` and the feature files the request touches. Only if the map does not answer where the change goes, send one `ult:scout` with a specific question. Then tell the user in two sentences what they want and the smallest change that delivers it. Do not wait for a reply.

3. **Goal.** Write the goal contract with the `ult:goal` skill. From an issue, its `Done when` lines are the checks. Every check in it must be red or absent now. For a bug, the `ult:debug` skill produces the reproduction that becomes the check.

4. **Plan.** Run the steps of `ult:plan`: reuse, cut, route, slices, size.
   - An algorithmic core, an invariant or an optimization: the first slice is `ult:prove`.
   - A change to what users see: the first slice is `ult:design`.
   - Module shape follows `ult:garden`.

   Write the goal contract and the plan as a checklist to `.ult/task.md`, with the branch name and any decision you made by default. This file is your memory across context compaction: tick a slice the moment it is committed, and add a line whenever you learn something the next slice depends on.

5. **Build, one slice at a time.**
   - Write the failing test at the public interface, then the least code that passes it.
   - Run the `fast` check through the quiet runner after each slice.
   - Green is the midpoint. Do the second-draft pass of `ult:garden` with the check as guard.
   - Commit the slice. Conventional Commits title, body only when the reason is not obvious from the diff. Tick it in `.ult/task.md`.
   - A problem outside the goal goes to `ult:defer`, not into the diff.

6. **Verify.** Run the `full` check through the quiet runner. If it fails with more failures than the tail shows, hand the log path to `ult:verifier` for a grouped summary. Then run every check in the goal contract and keep the output. For user-visible behavior, drive the real app (CLI, HTTP call or browser) and capture what you saw. "It compiles" and "tests pass" are not evidence that the feature works. Last, prove the checks bite with the mutant step of `ult:goal`.

7. **Read your own diff.** The reviewer is the second reader, never the first. Read `git diff <base>...HEAD` once, top to bottom, as if someone else wrote it. For each hunk: which input breaks it, who else calls what it changed, does the goal need it. If `.ult/findings.tsv` exists, read its last 20 lines first and look for those kinds of mistake: they are what review caught in this repo before. Fix what you find and rerun the checks.

8. **Review and grade.** Run the code loop in `ult:grade`: one review by `ult:reviewer` with the base branch, the goal contract and the mutant count, then one recheck of the fixes. `CLEAN` is a normal result; do not ask for another review to be sure. UI work was graded in `ult:design`; do not grade it twice.

9. **Map.** If behavior, entry points or verification commands changed, update `docs/map/` in this branch with the `ult:map` skill.

10. **PR.** Open it with the `ult:pr` skill and apply its merge gate. From an issue, the body ends with `Closes #<number>`.

11. **Report and close.** Delete `.ult/task.md`. At most 8 lines: what shipped, the PR link, merged or waiting and why, check results, grades, issues opened, lessons encoded. From a sub-issue, end with the next open part of the parent whose blockers are closed (`/ult:next` finds it):

    ```
    Next: in a new session (/clear), `/ult:ship #<number>`
    ```

## Stop and ask only when

- The request has two readings that lead to different products and no default is clearly safer.
- The change needs a one-way door the user did not ask for: data migration, deleted data, public API break, new paid service, new production dependency with a real alternative.
- You cannot build any check that can fail for the goal.
- Three approaches to the same slice have failed. Report what you tried and what each showed.

Anything else, choose the conservative option, write the choice in the PR and continue.
