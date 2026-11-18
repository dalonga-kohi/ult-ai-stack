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

The agent interrogates you about what the feature is for and how it should behave, one decision at a time, with its recommended answer or best guess attached. It does not agree to be agreeable: its first reply names the strongest reason the feature may not be worth building, every load-bearing answer has to survive a probe (when did this last happen, what does it cost today, why not the existing tool, what happens at ten times the size) before it is recorded, and when you overrule an objection without new evidence the decision stays yours but the objection is written down as a risk. How it is built is its call: it reads the code, researches how established products handle the same feature, and records those choices as defaults you can veto. It pins down vague terms, reads its understanding back to you, and points out where an answer contradicts the code, the product doc or an earlier answer. Once every branch is decided, it writes the plan as issues, not as a doc in the repo: a parent issue labeled `epic` holds the whole record (why, scenarios, requirements and edge cases with stable ids like `R1` and `E1`, each with the check that proves it, terms, decisions, risks), and one sub-issue per part, each sized for one fresh session. Every sub-issue is self-contained: it states in full every requirement, edge case, term and decision its part needs, so the session that builds it reads the issue and the code and nothing else. Then `goldfish`, an agent that can read nothing but the files it is handed, gets one sub-issue at a time and tries to build from it: every guess it has to make, every line it would have to look up elsewhere, every requirement no check could fail. A second goldfish reads the whole set for requirements no part covers and parts that disagree. What the interview settled gets fixed in the drafts; what it did not becomes your next question. Then the issues are filed:

```
Epic: #40 invoices: PDF export (7 requirements, 5 edge cases)
Parts: #41 single invoice to PDF | #42 batch export (after #41) | #43 branding
Start: in a new session (/clear), `/ult:ship #41`
```

Then do the parts one by one, each in a clean session: `/ult:ship #41` reads the issue, writes its goal from `Done when`, and opens a PR that closes it. `/ult:next` names the next open part whose blockers are closed. If `ult:ship` gets a request that turns out to be Large, it builds nothing and starts the interview.

It asks you something only when a decision is a one-way door or the request has two readings that lead to different products.

A project that does not exist yet starts one level up:

```
/ult:new a tool that tells me which of my subscriptions I forgot about
```

This is plan mode for a whole product. The agent writes no code. It interviews you on purpose first (who has the problem, the last time it happened, what you do today, why nothing existing fits), then the concept, the boundaries and what good looks like, while a research agent maps the prior art and the standards in the background. Findings come back as questions: "X already does A and B but not C. Is C why you want this?" Foundational technical choices (where it runs, where data lives, identity, hosting, license) are researched and decided, and only the ones you will feel are asked, in terms of consequences. The result is committed and filed:

```
docs/PRODUCT.md       problem, users, core loop, concepts, scenarios, scope, quality bar, risks, open
docs/RESEARCH.md      prior art, standards, what is borrowed, why build
docs/adr/0001-*.md    one file per foundational decision, with the options rejected
Epics: #1 <capability> (4 parts) | #6 <capability> (3 parts)
Start: in a new session (/clear), `/ult:ship #2`
```

Before you see the docs, `goldfish`, reading only `PRODUCT.md` and the ADRs, must answer who it is for, the core loop, what it will never do and what to build first, and then attack them. Every guess it makes is a hole that gets fixed, and every hole the interview did not settle comes back to you as a question. The issue drafts get the same cold read before they are filed. The first part filed is always the walking skeleton: the core loop working once, end to end, with checks and CI, so every later part has something to build on.

## What is in it

**Always on** (`hooks/core.md`, about 400 words, injected at session start): ten rules covering goal before code, one change per check, never weakening a check, comments, tending the codebase, deferring with issues, guarding context, code as the single source of truth, encoding lessons, and terse chat with factual reports.

**Skills**, loaded only when needed:

| Skill | Purpose |
| --- | --- |
| `ship` | The end-to-end workflow above, from a request or from an issue |
| `new` | Plan mode for a new project: interrogate purpose and concept, research the prior art, write `PRODUCT.md`, `RESEARCH.md` and ADRs, cold-read them, file the first epics with sub-issues |
| `grill-me` | Interrogate the user on the purpose and behavior of a feature, with research, then file it as an epic issue with self-contained sub-issues, one per session-sized part, each cold-read alone. Holds the interview technique both skills share |
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
| `researcher` | Sonnet | Answer one research question from primary sources: prior art, standards, where each option breaks, with dates and links |
| `reviewer` | Sonnet | Read the diff until it can explain it, report only defects it can demonstrate, and grade it: correct, proven, simple, fits. A clean result is normal. Rechecks its own findings after the fixes |
| `critic` | Sonnet | Judge the rendered UI from screenshots alone and grade it: works, clear, decided, finished, copy |
| `goldfish` | Sonnet | Read planning docs with no memory and only the `Read` tool, say what it would build from them, then attack them: holes, conflicts, untestable lines, unbacked assumptions, undecided cases, broken traceability, and the strongest case the plan is wrong. `READY` or `NOT READY` |

**Drift check** (`bin/ult-doccheck`, `bin/ult-doccheck.ps1`): verifies every path, symbol and link in `docs/map/`. One `PASS` line, or one `BROKEN` line per stale pointer.

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

**The user owns the what, the agent owns the how.** Interviews go wrong in three ways: the agent asks about libraries the user does not care about, it builds on a first sentence the user would have corrected, or it agrees with whatever it hears. So the interview splits decisions by owner. Purpose, concept, boundaries and quality are asked, in that order, because each answer reframes the next. Implementation is decided by the agent from the code and research and shown as a default. The techniques come from interviewing practice: ladder a solution up to its need and an abstraction down to an instance, ask about the last time instead of a hypothetical, lead with a guess because correcting is easier than authoring, read the whole idea back every few answers, and run a pre-mortem. The interview stops when the agent can predict the next answer and its strongest remaining objection has been answered, not at a question count.

**Agreement is not help.** A model's default in conversation is to agree, and an agreeable interviewer lets a weak idea through to the one stage where fixing it costs a rebuild. So the interview runs as an interrogation: no praise, the weakest point first, a probe before each load-bearing answer is recorded, the user's view steelmanned before it is attacked. The opposite failure is real too, contrarianism that burns the user's attention, so every challenge must be able to change a decision, the agent concedes plainly when the evidence goes against it, and an overruled objection is recorded once, as a risk, not repeated. The user still owns every product decision; the stack only makes sure each one was tested.

**Research before asking.** A question a search can answer wastes the user's attention, and an idea that already exists is the most expensive thing to rediscover after building it. A Sonnet researcher reads primary sources, checks that a project is alive, looks for where each option breaks in its users' complaints, and names the standard when one exists. It runs in the background while the interview continues, and its findings return as recommendations or as the next question.

**Code is the single source of truth; docs say why.** A fact written in two places drifts: the code changes, the copy does not, and the next session builds from the copy. So each fact has one home. How something works, its values, formats and exact behavior, lives in the code and its tests. What a feature does and why it exists lives in its map file, in product words, with pointers to the symbols and tests that hold the detail, and it changes in the same PR as the code. `PRODUCT.md` says who the product is for and what it will never do; ADRs record decisions that cost more than a PR to reverse, dated and never edited, so they cannot drift. Durable docs never state a value or a signature the code holds; the goldfish flags one as `COPY`. Docs are written for an agent reading cold: fixed headings, the answer in the first line, one fact per bullet, unknowns in a visible `Open` section, a size cap so each loads in one read.

**Issues carry the plan in full, then die.** Requirements need a home before code exists, and that home is the issue. A sub-issue states everything its part needs, written out, because a fresh session that has to chase references through other docs guesses at the gaps. Copying is safe there and nowhere else: the issue is read once, its PR closes it, and from then on the tests are the requirement. A decision that changes while parts are still open is edited into each open issue that carries it, with a dated line.

**Drift is caught by a script, not by care.** `bin/ult-doccheck` reads `docs/map/` and fails on every backticked path that no longer exists, every symbol that no longer occurs in the file named before it, and every dead relative link. `ult:ship` runs it on every change, so a rename that forgets the map fails before the PR.

**The author cannot see the holes in its own doc.** It knows what it meant, so it reads the meaning into the gaps. The cold reader is therefore an agent with no memory and one tool, `Read`, given the file paths and nothing else: no summary, no conversation, no repo. That is exactly the position of every later session. It first says what it would build and quotes its source, so a guess shows up as a guess, and then attacks the docs by fixed categories. A finding must point at a line and change what gets built, so wording and taste are excluded. A second round uses a new goldfish that has not seen the first, at most two rounds, and anything left standing is written into the doc as `Open` or `Risks` rather than hidden.

**Big work is decided first, then split into issues.** One oversized change is reviewed badly, verified badly and reverted whole, and the session that builds it fills its context before the end, so its last decisions are its worst. `ult:plan` has four size tests. Past any of them nothing is built: `grill-me` moves the decisions to the user while the user is there, then files parts that each pass the size tests. A part is an issue, not a line in a reply, so it survives the session. Its body holds everything the part needs, so a fresh session starts from a clean context and reads one issue to know what to build.

**Generated UI is a default, so the fix is a decision.** A ban list alone moves the model to the next most common choice. The design skill therefore asks for three candidate directions and treats the first as the one everybody gets, requires three named departures from the default with a reason each, and pairs every tell in `SLOP.md` with what to do instead. Copy gets the same treatment in `COPY.md`: four tests (swap, proof, spoken, delete) before a list of words. The part a regex can catch (gradient text, dead links, placeholder names, stock phrases, emoji icons) is in `tells.txt` and is found by `rg` at no model cost. The rest is judged by the critic from screenshots.

**Comments are a symptom.** A comment that explains a workaround is where the code should have been fixed. The policy allows three kinds (public API contract, linked external constraint, license), the reviewer audits every added comment, and the commit guard catches the markers.

**The codebase is a garden.** Smallest diff, delete before adding, deep modules, three uses before an abstraction, migrate then delete. Mess outside the task becomes an issue, so diffs stay reviewable and nothing is forgotten.

**Proof where proof pays.** Lean is used for algorithmic cores only: an optimized version proven equal to an obvious one, or an invariant proven for every input. The proof covers a model, so the skill requires property-based and differential tests that tie the model to the shipped code.

**Auto-merge is narrow on purpose.** A PR merges itself only when it is a two-way door, stays in one feature area, avoids auth, payments, schema, public API, dependencies and infrastructure, has green CI, and passed review with no blocker. Everything else waits for you.

**Terse in chat, plain on disk.** Every output token is paid for and read. Chat answers come first, without greeting, hedging, recap or closer, and code, paths, numbers and errors stay verbatim. Negations are never dropped, because a lost "not" costs more than every token saved. Warnings, irreversible actions, ordered steps and questions to the user stay in full sentences, and everything persisted (code, commits, docs, issues, PRs) stays plain prose for the next reader. Adapted from the caveman skill.

**Lessons become structure.** A correction or a repeated mistake is turned into a test, a type, a lint rule or a map gotcha, so the next session cannot repeat it and no context is spent remembering it.

**Few parts.** Sixteen skills and seven agents. A rule is in the stack only if an agent does worse without it.

## Changing it

Edit the files and run `bash scripts/check.sh`. It validates the manifests, enforces the size budgets in `CLAUDE.md`, checks links, tests the tells file against sample markup, keeps the two graders on one scale and tests the hooks and the runner in bash and, when `pwsh` or `powershell` is installed, in PowerShell. CI runs it on Ubuntu and Windows. Tune first:

- `skills/pr/SKILL.md`, section "Merge gate": what may merge without you.
- `skills/design/REFERENCES.md`: the sites you consider the best.
- `skills/design/SLOP.md`, `COPY.md` and `tells.txt`: what you count as a tell. Add one whenever you spot a new giveaway.
- `skills/grill-me/INTERVIEW.md`: how hard the interview pushes, how it asks, what it leaves to the agent and when it stops.
- `skills/new/DOCS.md`: the doc templates and the rules for agent-readable docs. `agents/goldfish.md`: what the cold reader counts as a weak point and when it says `READY`.
- `skills/plan/SKILL.md`, step "Size": when work counts as too big for one pull request.
- `agents/reviewer.md`, section "Admit a finding only when": how strict the reviewer is.
- `skills/grade/SKILL.md`, section "Loop": the bar. The rubrics are in `agents/reviewer.md` and `agents/critic.md`.
- `skills/garden/TS.md` and `SYSTEMS.md`: your stack conventions.
- `hooks/core.md`: the always-on rules. Keep it under 450 words.

See [CREDITS.md](CREDITS.md) for the projects this draws on.
