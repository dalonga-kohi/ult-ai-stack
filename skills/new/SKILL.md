---
name: new
description: Turn a loose idea into a defined project. Interrogate purpose and concept, research prior art, then write docs/PRODUCT.md and ADRs, test them with a cold reader, and file the first epics with sub-issues. Writes no code. Use when starting a project from scratch.
argument-hint: <the idea, however loose>
---

# New project

This is plan mode for a whole product. The idea as first stated is where the work starts, not a spec. The job is to find out what the user actually wants, test it against what already exists, and write it down so that every later session builds the right thing without the user in the room. Until the interview and the foundations are settled, write nothing except `.ult/grill.md`. Write no code at all: `ult:ship` builds each part later, in its own session.

## 1. Start

- If the directory already holds a product's code, this is not a new project. Run `ult:grill-me` instead.
- If `.ult/grill.md` starts with `# new:`, the interview is resuming. Read it and continue from the first `Open` line.
- Otherwise write the idea verbatim to `.ult/grill.md`. Reply with what you think it is in two sentences, the strongest reason it may not be worth building, the three unknowns that would change it most, and the first purpose question.
- In the same turn, start one `ult:researcher` in the background on prior art. Give it the idea, its purpose as you understand it, and the question "what already does this, how well, and where does it fall short?"

## 2. Interview

Run [INTERVIEW.md](../grill-me/INTERVIEW.md), stance first, through all five layers. Spend most questions and most challenges on purpose and concept. A weak answer there makes everything below it wrong, and no amount of engineering recovers it.

When the prior-art report arrives, put it to the user as an objection, not a summary: "<X> already does A and B but not C. Is C enough to make someone switch, or is it something else?" If the report says nothing is missing, say plainly that the user may not need to build this, and ask why they still would. When the concept shifts, research again, because a new angle has different prior art. Each later question that research can answer goes to its own `ult:researcher` in the background while you ask something else.

## 3. Foundations

List the technical decisions the product forces now and that would cost more than one pull request to reverse: where it runs, language and runtime, where data lives and who owns it, how users identify themselves, hosting and its cost, license, distribution. Every other choice belongs to the session that builds it.

For each, send one `ult:researcher` with the constraints from the interview and ask for 2 or 3 options. Choose by fit with the product decisions first, then the fewest moving parts, then the most maintained ecosystem. Ask the user only about the one-way doors they will feel, in terms of consequences (INTERVIEW.md, "Who decides what"). Record the rest as `[default]`.

## 4. Docs

Write `docs/PRODUCT.md`, `docs/RESEARCH.md` and one `docs/adr/NNNN-<slug>.md` per foundation with [DOCS.md](DOCS.md), following its rules for agent readers. Every line traces to a recorded decision, a challenge or a cited finding. A gap you notice while writing is a question for the user, not a guess in the doc.

**Cold read.** Run the cold read in [DOCS.md](DOCS.md) on `docs/PRODUCT.md` and the ADRs, with these questions: who is this for, what problem does it solve, what is the core loop, what will it never do, how will we know it works, what would you build first.

Show the user the `Scope` section, the ADR titles, the contested decisions and what the goldfish left under `Open` or `Risks` (at most 20 lines), point to the files, and revise until they approve.

## 5. Epics

Each capability under `First version` in `docs/PRODUCT.md` becomes one epic, named as an outcome a user would recognize. Split each epic into parts by step 3 of `ult:grill-me`. A part is the unit of work. Plan no slices, milestones or dates inside it: `ult:ship` slices a part when it builds it.

The first part of the first epic is the walking skeleton: the thinnest path through the core loop, end to end on the stack the ADRs chose, with a `fast` check, a `full` check and CI that runs them. Its done-check is the core loop working once through the real entry point. Every other part builds on it.

Write each part's body with [ISSUES.md](../grill-me/ISSUES.md) to `.ult/epic/<e>/<k>.md` and run the cold read on them, each judged with `docs/PRODUCT.md` and the ADRs as the only files its builder will read. Then show every epic with its parts, one line per part, and ask once to confirm. Revise until the user agrees.

## 6. Repository and issues

1. If this is not a git repository, run `git init`. Add `.ult/` to `.gitignore`.
2. Add the `Product` section from DOCS.md to `CLAUDE.md`, creating the file if it is absent.
3. Commit the docs: `docs: define <name>: product, research and decisions`.
4. With a GitHub remote, push the commit to its default branch. With none, ask for the repository name and whether it is public or private, then run `gh repo create <name> --private --source . --push` (or `--public`). This publishes the docs, so never guess the visibility.
5. File the epics in the agreed order with [ISSUES.md](../grill-me/ISSUES.md). A part cites `docs/PRODUCT.md` and the ADRs at the pin, by id, and copies none of their text. Then delete `.ult/grill.md`.

If `gh` is missing or logged out, keep the drafts in `.ult/epic/`, tell the user to run `gh auth login`, and file them once it works.

## 7. Report

```
Product: docs/PRODUCT.md: <one sentence>
Decisions: <n> ADRs: <short titles>
Epics: #<n> <title> (<k> parts) | #<m> <title> (<k> parts)
Start: in a new session (/clear), `/ult:ship #<walking skeleton>`
```

At most 8 lines. `/ult:next` names the next open part at any time.
