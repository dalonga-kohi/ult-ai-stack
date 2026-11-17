---
name: grill-me
description: Interview the user about a feature until its purpose and product decisions are settled, researching prior art along the way, then file it as an epic issue with sub-issues sized for one fresh session. Use for large or vague work, or to grill a plan.
argument-hint: <the feature or plan>
---

# Grill me

Large work goes wrong in one session for two reasons: the agent makes the decisions alone, and its context fills up before the end. This skill fixes both. The user makes the decisions now, and the work leaves as issues that each fit one fresh session. It writes no code. Adapted from Matt Pocock's `grill-me`, `grill-with-docs`, `to-prd` and `to-issues` (see CREDITS.md).

## 1. Ground

Read the repo's `CLAUDE.md`, `docs/PRODUCT.md` and `docs/adr/` if they exist, `docs/map/README.md` and the feature files the request touches. Send one `ult:scout` only when the map does not say where the work lands. If `.ult/grill.md` starts with `# grill-me:`, the interview is resuming: read it and continue from the first `Open` line.

## 2. Grill

Run [INTERVIEW.md](INTERVIEW.md). In an existing repo, the questions that matter are what the feature is for and how it behaves for the people who use it. The code answers how it is built: read it, follow its patterns, and record those choices as `[default]`.

- When the feature has prior art (export, search, sharing, notifications, permissions, billing), send one `ult:researcher` in the background on how established products handle it and what users expect, while you ask the purpose questions.
- When an answer contradicts `docs/PRODUCT.md` (a user it is not for, something under `Never`), quote the line. Either the answer or the product doc changes; the user decides which.
- A settled decision that is a one-way door by the test in [DOCS.md](../new/DOCS.md) becomes an ADR. Draft it with that template in the `Context` of the first part that depends on it; that part adds it to `docs/adr/`.

## 3. Slice

Split the work into parts. Each part:

- delivers one outcome that can be observed on its own, going through every layer it needs, and leaves the default branch working;
- is not Large by the size tests in step 6 of `ult:plan`, so a fresh agent can finish it before its context fills;
- has a done-check: a command, or a behavior in the real app, that fails today.

Order the parts the way `ult:plan` step 5 orders slices: the thinnest end-to-end path first, then the part most likely to prove the plan wrong, polish last. Record a blocker only when a part needs another part's code to exist. A part that needs something only the user can give (a decision deferred to later, access, a design) is marked `Needs you`.

Show the split, one line per part, then ask once to confirm it:

```
1. <title>: <outcome>
2. <title>: <outcome> (after 1)
```

Revise it until the user agrees. If the whole request fits in one part, it needs no parent: file it as a single issue.

## 4. File

Create the issues with [ISSUES.md](ISSUES.md): the parent, then the sub-issues in order, then the links. Each sub-issue body must stand alone for an agent that never saw this conversation. Restate the decisions it depends on; do not just point to the parent. Delete `.ult/grill.md` once the parent's body holds every decision.

If `gh` is missing or logged out, write the bodies to `.ult/epic/` (`parent.md`, `1.md`, `2.md`, ...), tell the user to run `gh auth login`, and file them once it works.

## 5. Report

```
Epic: #<n> <title> <url>
Parts: #<a> <title> | #<b> <title> (after #<a>) | ...
Start: in a new session (/clear), `/ult:ship #<first part>`
```

At most 8 lines. Each part starts in a fresh session, so the agent begins with a clean context. `/ult:next` names the next open part at any time.
