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
understand ─ goal ─ plan ─ build slice by slice ─ verify ─ self-read ─ review + grade ─ map ─ PR ─ merge gate
   map +      red    shortest  test, code, second    full +   own diff   one review,     update evidence  auto-merge
   scout     checks  path      draft, check, commit  mutants  first      one recheck            + risk    if low risk
```

Work too big for one pull request is not built in one go. Start it with an interview instead:

```
/ult:grill-me add PDF export
```

The agent questions you one decision at a time, gives its recommended answer with each question, and reads the code instead of asking whenever the code can answer. It pins down vague terms and points out where an answer contradicts the code or an earlier answer. Once every branch is decided, it splits the work into parts, each sized for one fresh session, and files them on GitHub as a parent issue labeled `epic` with one sub-issue per part. Every sub-issue holds the decisions it depends on, its done-check and what it builds on, so an agent that never saw the interview can do it:

```
Epic: #40 invoices: PDF export
Parts: #41 single invoice to PDF | #42 batch export (after #41) | #43 branding
Start: in a new session (/clear), `/ult:ship #41`
```

Then do the parts one by one, each in a clean session: `/ult:ship #41` reads the issue, writes its goal from `Done when`, and opens a PR that closes it. `/ult:next` names the next open part whose blockers are closed. If `ult:ship` gets a request that turns out to be Large, it builds nothing and starts the interview.

It asks you something only when a decision is a one-way door or the request has two readings that lead to different products.

## What is in it

**Always on** (`hooks/core.md`, about 350 words, injected at session start): nine rules covering goal before code, one change per check, never weakening a check, comments, tending the codebase, deferring with issues, guarding context, encoding lessons, and factual reports.

**Skills**, loaded only when needed:

| Skill | Purpose |
| --- | --- |
| `ship` | The end-to-end workflow above, from a request or from an issue |
| `grill-me` | Interview the user until every decision is made, then file the work as an epic issue with one sub-issue per session-sized part |
| `plan` | The shortest path to the goal: reuse, cut, choose a route, slice by risk. Sizes the work and sends anything too big for one pull request to `grill-me` |
| `next` | Where the work stands and the one thing to do next, with the command to paste, including the next open part of an epic |
| `brief` | Write the prompt for another agent, or turn a rough request into one: goal, context, done-check, limits, reply shape |
| `debug` | Reproduce, shrink, locate by halving, fix at the origin, pin with a regression test |
| `goal` | The goal contract: commands that decide whether the task is done. Includes the hillclimb loop for metrics |
| `map` | The feature map in `docs/map/`: what the product does, where each feature lives, how to verify it |
| `garden` | Module shape, pruning, what makes a module easy to replace, the second-draft pass and the comment policy, with stack files for TypeScript/React/Next.js and Rust/Go |
| `design` | Frontend workflow: study references, commit to a direction that departs from the default, build on tokens, write the copy, scan for tells, verify the render, grade it. With a craft floor, a catalog of generated-UI tells, copy rules, motion values and a reference list |
| `grade` | A 1 to 100 score from a fresh-context grader against a fixed rubric, for code, rendered UI and copy. Baseline before, score after, a bounded loop (for code: one review and one recheck), a score ledger and a findings ledger that feeds the next task |
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
| `reviewer` | Sonnet | Read the diff until it can explain it, report only defects it can demonstrate, and grade it: correct, proven, simple, fits. A clean result is normal. Rechecks its own findings after the fixes |
| `critic` | Sonnet | Judge the rendered UI from screenshots alone and grade it: works, clear, decided, finished, copy |

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

**A grade is an anchor, and the author never holds the pen.** Checks say whether the work does the job; a grade says how well, as a number comparable with the last one. A model asked to score its own work says 90, so the score comes from a subagent that sees only the result, never the previous score or the intent. Each grader lists findings first and derives the dimension scores from them: a dimension drops only with a finding that explains it, a blocker caps it at 59. The bar is 80 with no dimension under 60, every loop is bounded, and a move under 4 points counts as noise. Whatever a command can measure stays measured: metrics go through the hillclimb harness, and test strength is checked by breaking the finished code on purpose and counting the mutants the checks catch.

**A reviewer told to find problems always finds some.** Ask a fresh model for defects and it returns defects, real or not, and a new reviewer after every fix means the loop never ends. So the reviewer's job is stated as understanding: it reads the goal, the diff and the callers until it can explain the change, writes that down, and walks the behavior with real values. A finding is admitted only with a concrete scenario, in code this change touched, after an attempt to refute it; taste and hypothetical futures are excluded by name. `CLEAN` is described as the expected result. A suspicion it cannot demonstrate goes out as a `RISK` with the one check that would settle it, and never lowers the score. Scores start at 95 and only a listed finding lowers them, so there is no pressure to produce a finding to justify a number. The loop is one review and one recheck, and the recheck reads only the fixes.

**Review findings feed back.** Every finding is logged to `.ult/findings.tsv` with a kind and whether it was fixed or rejected. The author reads the recent ones before reading its own diff, so it looks for the mistakes it actually makes here. A kind fixed three times becomes a test, a type or a lint rule. A kind rejected three times for the same reason becomes one line of stated convention that the reviewer reads, so the same false finding stops coming back.

**Quality is built before the review.** The plan step removes work before any is done: reuse what exists, strike what the outcome does not need, choose the route with the fewest new concepts. Each slice gets a second-draft pass while its check is green, because the first version that passes was written before the answer was known. The author reads the whole diff once as a stranger before the reviewer sees it. Modular code is defined by what a module hides, so it can be replaced without adding layers.

**Big work is decided first, then split into issues.** One oversized change is reviewed badly, verified badly and reverted whole, and the session that builds it fills its context before the end, so its last decisions are its worst. `ult:plan` has four size tests. Past any of them nothing is built: `grill-me` moves the decisions to the user while the user is there, then files parts that each pass the size tests. A part is an issue, not a line in a reply, so it survives the session. Its body repeats the decisions it needs, which lets a fresh session start from a clean context without rediscovering them.

**Generated UI is a default, so the fix is a decision.** A ban list alone moves the model to the next most common choice. The design skill therefore asks for three candidate directions and treats the first as the one everybody gets, requires three named departures from the default with a reason each, and pairs every tell in `SLOP.md` with what to do instead. Copy gets the same treatment in `COPY.md`: four tests (swap, proof, spoken, delete) before a list of words. The part a regex can catch (gradient text, dead links, placeholder names, stock phrases, emoji icons) is in `tells.txt` and is found by `rg` at no model cost. The rest is judged by the critic from screenshots.

**Comments are a symptom.** A comment that explains a workaround is where the code should have been fixed. The policy allows three kinds (public API contract, linked external constraint, license), the reviewer audits every added comment, and the commit guard catches the markers.

**The codebase is a garden.** Smallest diff, delete before adding, deep modules, three uses before an abstraction, migrate then delete. Mess outside the task becomes an issue, so diffs stay reviewable and nothing is forgotten.

**Proof where proof pays.** Lean is used for algorithmic cores only: an optimized version proven equal to an obvious one, or an invariant proven for every input. The proof covers a model, so the skill requires property-based and differential tests that tie the model to the shipped code.

**Auto-merge is narrow on purpose.** A PR merges itself only when it is a two-way door, stays in one feature area, avoids auth, payments, schema, public API, dependencies and infrastructure, has green CI, and passed review with no blocker. Everything else waits for you.

**Lessons become structure.** A correction or a repeated mistake is turned into a test, a type, a lint rule or a map gotcha, so the next session cannot repeat it and no context is spent remembering it.

**Few parts.** Fourteen skills and five agents. A rule is in the stack only if an agent does worse without it.

## Changing it

Edit the files and run `bash scripts/check.sh`. It validates the manifests, enforces the size budgets in `CLAUDE.md`, checks links, tests the tells file against sample markup, keeps the two graders on one scale and tests the hooks and the runner in bash and, when `pwsh` or `powershell` is installed, in PowerShell. CI runs it on Ubuntu and Windows. Tune first:

- `skills/pr/SKILL.md`, section "Merge gate": what may merge without you.
- `skills/design/REFERENCES.md`: the sites you consider the best.
- `skills/design/SLOP.md`, `COPY.md` and `tells.txt`: what you count as a tell. Add one whenever you spot a new giveaway.
- `skills/plan/SKILL.md`, step "Size": when work counts as too big for one pull request.
- `agents/reviewer.md`, section "Admit a finding only when": how strict the reviewer is.
- `skills/grade/SKILL.md`, section "Loop": the bar. The rubrics are in `agents/reviewer.md` and `agents/critic.md`.
- `skills/garden/TS.md` and `SYSTEMS.md`: your stack conventions.
- `hooks/core.md`: the always-on rules. Keep it under 350 words.

See [CREDITS.md](CREDITS.md) for the projects this draws on.
