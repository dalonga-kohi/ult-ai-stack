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

1. **Preflight.** Confirm the working tree is clean and create a branch from the default branch (`feat/<slug>` or `fix/<slug>`). Read the `## Checks` section of the repo's `CLAUDE.md`. If it is missing, run the `ult:setup` skill first.

2. **Understand.** Read `docs/map/README.md` and the feature files the request touches. Only if the map does not answer where the change goes, send one `ult:scout` with a specific question. Then tell the user in two sentences what they want and the smallest change that delivers it. Do not wait for a reply.

3. **Goal.** Write the goal contract with the `ult:goal` skill. Every check in it must be red or absent now.

4. **Plan.** Split the work into vertical slices. Each slice goes through every layer it needs and ends in a check that passes. List the slices in at most 10 lines. If the task has an algorithmic core, an invariant or an optimization, the first slice is `ult:prove`. If it changes what users see, the first slice is `ult:design`. For module shape, follow `ult:garden`.

5. **Build, one slice at a time.**
   - Write the failing test at the public interface, then the least code that passes it.
   - Run the `fast` check yourself after each slice. It must print little; if it does not, hand it to `ult:verifier`.
   - Commit the slice. Conventional Commits title, body only when the reason is not obvious from the diff.
   - A problem outside the goal goes to `ult:defer`, not into the diff.

6. **Verify.** Hand the `full` check to `ult:verifier`. Then run every check in the goal contract yourself and keep the output. For user-visible behavior, drive the real app (CLI, HTTP call or browser) and capture what you saw. "It compiles" and "tests pass" are not evidence that the feature works.

7. **Review.** Spawn `ult:reviewer` with the base branch and the goal contract. Fix every BLOCKER and every SHOULD you agree with; say in one line why you rejected any other. Run a second review only if the first found a BLOCKER. Rerun the checks after fixes.

8. **Map.** If behavior, entry points or verification commands changed, update `docs/map/` in this branch with the `ult:map` skill.

9. **PR.** Open it with the `ult:pr` skill and apply its merge gate.

10. **Report.** At most 8 lines: what shipped, the PR link, merged or waiting and why, check results, issues opened.

## Stop and ask only when

- The request has two readings that lead to different products and no default is clearly safer.
- The change needs a one-way door the user did not ask for: data migration, deleted data, public API break, new paid service, new production dependency with a real alternative.
- You cannot build any check that can fail for the goal.
- Three approaches to the same slice have failed. Report what you tried and what each showed.

Anything else, choose the conservative option, write the choice in the PR and continue.
