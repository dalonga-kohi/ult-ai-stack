---
name: grill-me
description: Interrogate the user on a feature until its purpose and behavior survive challenge, research prior art, write a spec in docs/specs, test it with a cold reader, then file an epic with session-sized sub-issues. Use for large or vague work, or to grill a plan.
argument-hint: <the feature or plan>
---

# Grill me

Large work goes wrong in one session for three reasons: the agent makes the decisions alone, nobody attacks the idea before it is built, and the context fills up before the end. This skill fixes all three. The user makes the decisions now, under questioning; a written spec survives a cold reader; and the work leaves as issues that each fit one fresh session. It writes no code. Adapted from Matt Pocock's `grill-me`, `grill-with-docs`, `to-prd` and `to-issues` (see CREDITS.md).

## 1. Ground

Read the repo's `CLAUDE.md`, `docs/PRODUCT.md`, `docs/adr/` and `docs/specs/` if they exist, `docs/map/README.md` and the feature files the request touches. Send one `ult:scout` only when the map does not say where the work lands. If `.ult/grill.md` starts with `# grill-me:`, the interview is resuming: read it and continue from the first `Open` line.

Otherwise write the request verbatim to `.ult/grill.md` and reply with what you think it is in two sentences, the strongest reason it may not be worth building, and the first question.

## 2. Grill

Run [INTERVIEW.md](INTERVIEW.md), stance first. In an existing repo, the questions that matter are what the feature is for and how it behaves for the people who use it. The code answers how it is built: read it, follow its patterns, and record those choices as `[default]`.

- When the feature has prior art (export, search, sharing, notifications, permissions, billing), send one `ult:researcher` in the background on how established products handle it, where users complain about it and what they expect, while you ask the purpose questions. Bring its findings back as objections or recommendations.
- When an answer contradicts `docs/PRODUCT.md` (a user it is not for, something under `Never`) or an existing spec, quote the line. Either the answer or the doc changes; the user decides which.
- A settled decision that is a one-way door by the test in [DOCS.md](../new/DOCS.md) becomes an ADR. Draft it with that template in the `Context` of the first part that depends on it; that part adds it to `docs/adr/`.

## 3. Spec

Write `docs/specs/<slug>.md` with the spec template in [DOCS.md](../new/DOCS.md), following its rules for agent readers. Every line traces to a decision, a challenge or a finding in `.ult/grill.md`. A gap you notice while writing is a question for the user, not a guess in the spec.

## 4. Slice

Split the work into parts. Each part:

- delivers one outcome that can be observed on its own, going through every layer it needs, and leaves the default branch working;
- is not Large by the size tests in step 6 of `ult:plan`, so a fresh agent can finish it before its context fills;
- covers named `R` and `E` ids, and every id is covered by exactly one part;
- has a done-check: a command, or a behavior in the real app, that fails today.

Order the parts the way `ult:plan` step 5 orders slices: the thinnest end-to-end path first, then the part most likely to prove the plan wrong, polish last. Record a blocker only when a part needs another part's code to exist. A part that needs something only the user can give (a decision deferred to later, access, a design) is marked `Needs you`.

Fill the spec's `Parts` table, then write each sub-issue body with [ISSUES.md](ISSUES.md) to `.ult/epic/1.md`, `2.md`, ... without filing yet.

## 5. Cold read

Run the cold read in [DOCS.md](../new/DOCS.md) on the spec and every draft in `.ult/epic/`. Tell the goldfish to judge each draft with the spec as the only files its builder will read, and to ask of each: what do you build, how do you know you are done, what is not yours, and does every id it cites exist.

Then show the user the spec's `Requirements` and `Parts`, the contested decisions with your objection, and what the goldfish left under `Open` or `Risks` (at most 20 lines). Revise until they approve. If the whole request fits in one part, it needs no parent: it will be filed as a single issue.

## 6. Commit and file

1. Commit the spec on a branch `docs/<slug>` (`docs: spec <feature>`), push it and open a pull request with `gh pr create --body-file`. The user approved its content in step 5, so merge it with `gh pr merge --squash --delete-branch` once CI is green. Issues cite the spec at a commit on the default branch, so nothing is filed before the merge. If branch protection requires a review, keep the drafts in `.ult/epic/`, report the open PR, and file once it is merged.
2. File the issues with [ISSUES.md](ISSUES.md): the parent, then the sub-issues in order, then the links. Each part cites the spec at the pin and the ids it covers and rests on, and copies none of their text. The first part's pull request fills the issue numbers into the spec's `Parts` table.
3. Delete `.ult/grill.md` once the spec holds every decision.

If `gh` is missing or logged out, keep the drafts in `.ult/epic/`, tell the user to run `gh auth login`, and file them once it works.

## 7. Report

```
Spec: docs/specs/<slug>.md (<n> requirements, <n> edge cases) <PR url, merged | open>
Epic: #<n> <title> <url>
Parts: #<a> <title> | #<b> <title> (after #<a>) | ...
Contested: <decisions the user kept over an objection | none>
Start: in a new session (/clear), `/ult:ship #<first part>`
```

At most 8 lines. Each part starts in a fresh session, so the agent begins with a clean context. `/ult:next` names the next open part at any time.
