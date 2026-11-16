---
name: ship
description: Take a feature or fix from request to pull request, end to end. Use when the user asks to implement, build, add or fix something and wants it shipped.
argument-hint: <what to build>
---

# Ship

You own the outcome from request to PR. Do not stop to ask for approval between steps. Stop only at the conditions listed at the end.

## Size the work first

- **Small**: one module, the change is obvious, about 30 lines or fewer. Skip steps 2 and 4. Still write the goal and still verify.
- **Standard**: everything else. Run every step.

## Steps

1. **Preflight.** If `.ult/task.md` exists, this is a resumed task: read it and continue from the first unticked slice. Otherwise confirm the working tree is clean and create a branch from the default branch (`feat/<slug>` or `fix/<slug>`). Read the `## Checks` section of the repo's `CLAUDE.md`. If it is missing, run the `ult:setup` skill first.

2. **Understand.** Read `docs/map/README.md` and the feature files the request touches. Only if the map does not answer where the change goes, send one `ult:scout` with a specific question. Then tell the user in two sentences what they want and the smallest change that delivers it. Do not wait for a reply.

3. **Goal.** Write the goal contract with the `ult:goal` skill. Every check in it must be red or absent now. For a bug, the `ult:debug` skill produces the reproduction that becomes the check.

4. **Plan.** Split the work into vertical slices. Each slice goes through every layer it needs and ends in a check that passes. At most 10 lines.
   - An algorithmic core, an invariant or an optimization: the first slice is `ult:prove`.
   - A change to what users see: the first slice is `ult:design`.
   - Two plausible approaches and no way to choose by reading: spike the riskiest part on a throwaway branch, keep what you learned, discard the code.
   - Module shape follows `ult:garden`.

   Write the goal contract and the slices as a checklist to `.ult/task.md`, with the branch name and any decision you made by default. This file is your memory across context compaction: tick a slice the moment it is committed, and add a line whenever you learn something the next slice depends on.

5. **Build, one slice at a time.**
   - Write the failing test at the public interface, then the least code that passes it.
   - Run the `fast` check through the quiet runner after each slice.
   - Commit the slice. Conventional Commits title, body only when the reason is not obvious from the diff. Tick it in `.ult/task.md`.
   - A problem outside the goal goes to `ult:defer`, not into the diff.

6. **Verify.** Run the `full` check through the quiet runner. If it fails with more failures than the tail shows, hand the log path to `ult:verifier` for a grouped summary. Then run every check in the goal contract and keep the output. For user-visible behavior, drive the real app (CLI, HTTP call or browser) and capture what you saw. "It compiles" and "tests pass" are not evidence that the feature works. Last, prove the checks bite with the mutant step of `ult:goal`.

7. **Review and grade.** Spawn `ult:reviewer` with the base branch, the goal contract and the mutant count. It returns findings and a 1 to 100 grade. Fix every BLOCKER, then run the loop in `ult:grade` to the bar. Rerun the checks after fixes. UI work was graded in `ult:design`; do not grade it twice.

8. **Map.** If behavior, entry points or verification commands changed, update `docs/map/` in this branch with the `ult:map` skill.

9. **PR.** Open it with the `ult:pr` skill and apply its merge gate.

10. **Report and close.** Delete `.ult/task.md`. At most 8 lines: what shipped, the PR link, merged or waiting and why, check results, grades, issues opened, lessons encoded.

## Stop and ask only when

- The request has two readings that lead to different products and no default is clearly safer.
- The change needs a one-way door the user did not ask for: data migration, deleted data, public API break, new paid service, new production dependency with a real alternative.
- You cannot build any check that can fail for the goal.
- Three approaches to the same slice have failed. Report what you tried and what each showed.

Anything else, choose the conservative option, write the choice in the PR and continue.
