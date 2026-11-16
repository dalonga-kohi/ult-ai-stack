# ult

A Claude Code plugin that takes a request ("implement this feature") to a pull request, and to a merge when the change is low risk. It is built around two aims: better code, and fewer tokens spent getting there.

## Install

```
/plugin marketplace add dalonga-kohi/ult-ai-stack
/plugin install ult@ult-ai-stack
```

Requirements: `git`, the GitHub CLI (`gh auth login`), and Lean 4 through `elan` if you want `ult:prove`. Works on Linux, macOS and Windows; see [Windows](#windows).

Then, once in each repository:

```
/ult:setup
```

It records the repo's check commands in `CLAUDE.md`, creates the feature map in `docs/map/` and confirms GitHub access.

## Use

```
/ult:ship add CSV export to the invoices page
```

or just ask for a feature in plain words. The agent then:

```
understand ─ goal ─ plan ─ build slice by slice ─ verify ─ review ─ map ─ PR ─ merge gate
   map +      red     ≤10      test, code, check,    full     fresh    update   evidence   auto-merge
   scout     checks   lines    commit                check    eyes              + risk     if low risk
```

It asks you something only when a decision is a one-way door or the request has two readings that lead to different products.

## What is in it

**Always on** (`hooks/core.md`, about 340 words, injected at session start): nine rules covering goal before code, one change per check, never weakening a check, comments, tending the codebase, deferring with issues, guarding context, encoding lessons, and factual reports.

**Skills**, loaded only when needed:

| Skill | Purpose |
| --- | --- |
| `ship` | The end-to-end workflow above |
| `debug` | Reproduce, shrink, locate by halving, fix at the origin, pin with a regression test |
| `goal` | The goal contract: commands that decide whether the task is done. Includes the hillclimb loop for metrics |
| `map` | The feature map in `docs/map/`: what the product does, where each feature lives, how to verify it |
| `garden` | Module shape, pruning and the comment policy, with stack files for TypeScript/React/Next.js and Rust/Go |
| `design` | Frontend workflow: study references, commit to a direction, build on tokens, verify the render. With a craft floor, motion values and a reference list |
| `prove` | Lean 4: model the algorithm, prove the property, tie the proof to the real code with property-based tests |
| `pr` | PR body with a visual summary, before-and-after evidence and merge danger, plus the auto-merge gate |
| `defer` | Open a GitHub issue for anything out of scope |
| `setup` | Per-repo bootstrap |

**Subagents**, each with a fixed, capped reply format:

| Agent | Model | Job |
| --- | --- | --- |
| `scout` | Haiku | Find code and report locations, not contents |
| `verifier` | Haiku | Group and trim a long failing check |
| `design-scout` | Haiku | Measure reference sites |
| `reviewer` | Sonnet | Review the diff with fresh context before the PR |

**Quiet runner** (`bin/ult-run`, `bin/ult-run.ps1`): wraps any check command. Success prints one line; failure prints the last 40 lines; the full log goes to `.ult/logs/`. Most check runs cost a few tokens and need no subagent.

**Task file** (`.ult/task.md`): `ship` writes the goal contract and the slice checklist here and ticks slices as they land. After context compaction or in a new session, the session-start hook points the agent back to it, so a long task resumes where it stopped.

**Hook**: the commit guard (`commit-guard.sh`, `commit-guard.ps1`) blocks a `git commit` that adds deferral markers or lint and type suppressions to code, unless the line references an issue number, and blocks `--no-verify`. The rule is enforced by a script, so it costs no context and cannot be argued with.

## Windows

Every script has a bash version and a PowerShell version with the same behavior, and Claude Code picks between them:

| Setup | Hooks run | Quiet runner |
| --- | --- | --- |
| Linux, macOS | `.sh` through `sh` | `bin/ult-run` |
| Windows with Git for Windows (Git Bash) | `.sh` through Git Bash | `bin/ult-run` |
| Windows without Git Bash | `.ps1` through PowerShell | `bin/ult-run.ps1` |

The commit guard watches `git commit` in both the Bash tool and the PowerShell tool. The PowerShell scripts run on Windows PowerShell 5.1 and PowerShell 7 and are started with `-ExecutionPolicy Bypass`, so no policy change is needed. `.gitattributes` keeps line endings at LF so the bash scripts survive a Windows checkout. Skills use only commands that are the same in both shells (`git`, `gh`, `rg`, `lake`).

For repos you work on from both systems, `/ult:setup` records check commands that run unchanged in both shells (a package script or task runner target, not an `&&` chain).

## Why it is built this way

**A verifiable goal replaces judgment calls.** Every task starts with a goal contract: commands and the output that means success, seen failing before work starts. That gives the agent what a reward signal gives a learner. It also removes the most expensive failure, which is declaring done on work that does not work.

**Context is the budget.** The always-loaded cost is about 1,000 tokens (core rules plus skill and agent descriptions). Everything else is behind a pointer: a skill body loads when its task comes up, and a reference file loads only when the skill's step calls for it. Check output goes through the quiet runner and exploration goes to a Haiku subagent that returns a few lines. The feature map means most tasks begin with a 60-line read instead of a search.

**Comments are a symptom.** A comment that explains a workaround is where the code should have been fixed. The policy allows three kinds (public API contract, linked external constraint, license), the reviewer audits every added comment, and the commit guard catches the markers.

**The codebase is a garden.** Smallest diff, delete before adding, deep modules, three uses before an abstraction, migrate then delete. Mess outside the task becomes an issue, so diffs stay reviewable and nothing is forgotten.

**Proof where proof pays.** Lean is used for algorithmic cores only: an optimized version proven equal to an obvious one, or an invariant proven for every input. The proof covers a model, so the skill requires property-based and differential tests that tie the model to the shipped code.

**Auto-merge is narrow on purpose.** A PR merges itself only when it is a two-way door, stays in one feature area, avoids auth, payments, schema, public API, dependencies and infrastructure, has green CI, and passed review with no blocker. Everything else waits for you.

**Lessons become structure.** A correction or a repeated mistake is turned into a test, a type, a lint rule or a map gotcha, so the next session cannot repeat it and no context is spent remembering it.

**Few parts.** Ten skills and four agents. A rule is in the stack only if an agent does worse without it.

## Changing it

Edit the files and run `bash scripts/check.sh`. It validates the manifests, enforces the size budgets in `CLAUDE.md`, checks links and tests the hooks and the runner in bash and, when `pwsh` or `powershell` is installed, in PowerShell. CI runs it on Ubuntu and Windows. Tune first:

- `skills/pr/SKILL.md`, section "Merge gate": what may merge without you.
- `skills/design/REFERENCES.md`: the sites you consider the best.
- `skills/garden/TS.md` and `SYSTEMS.md`: your stack conventions.
- `hooks/core.md`: the always-on rules. Keep it under 350 words.

See [CREDITS.md](CREDITS.md) for the projects this draws on.
