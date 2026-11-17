---
name: grill-me
description: Interview the user about a feature until every decision is made, then split it into a parent GitHub issue with sub-issues, each small enough for one fresh session. Use for large or vague work, or when asked to grill a plan.
argument-hint: <the feature or plan>
---

# Grill me

Large work goes wrong in one session for two reasons: the agent makes the decisions alone, and its context fills up before the end. This skill fixes both. The user makes the decisions now, and the work leaves as issues that each fit one fresh session. It writes no code. Adapted from Matt Pocock's `grill-me`, `grill-with-docs`, `to-prd` and `to-issues` (see CREDITS.md).

## 1. Ground

Read the repo's `CLAUDE.md`, `docs/map/README.md` and the feature files the request touches. Send one `ult:scout` only when the map does not say where the work lands.

Keep the interview in `.ult/grill.md`: the request on the first line, then one line per settled decision. If the file already exists, the interview is resuming. Read it and continue from the first open question.

## 2. Grill

List what must be decided and which decisions depend on which. Walk that tree from the root, one question per message:

- Ask only what you cannot answer yourself. When the code, the map or the docs answer a question, read them and state the answer instead of asking it.
- A question earns its place when two plausible answers lead to different code. Skip trivia.
- Give your recommended answer and a one-line reason, so the user can just reply "yes". When the choice is between discrete options, use AskUserQuestion with 2 to 4 options and put the recommended one first.
- When an answer contradicts the code, the map or an earlier answer, quote the path or the earlier decision. That contradiction is the next question.
- Pin down any overloaded word ("account", "export", "user", "sync") before the decisions that depend on it. Write the agreed meaning under `Terms`.
- Ask about what the user skipped: empty, failure and permission cases, existing data, the other callers of whatever changes, how each outcome will be verified.
- Append the settled decision to `.ult/grill.md` as `<question> -> <answer>` before asking the next question.

Stop when every branch is either decided or listed as out of scope. Show the decisions (at most 15 lines) and ask once whether anything is wrong or missing.

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
