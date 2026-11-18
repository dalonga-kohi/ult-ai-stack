# Docs

Where each kind of knowledge lives, the rules every doc follows, the templates for `PRODUCT.md`, `RESEARCH.md` and ADRs, and the cold read that tests them. Read "Where truth lives" before writing any doc or issue.

## Where truth lives

A fact written in two places drifts: the code changes, the copy does not, and the next session builds from the copy. So each kind of fact has one home.

| Fact | Home | Lifetime |
| --- | --- | --- |
| How it works, exact behavior, values, formats, signatures | the code and its tests | always current |
| What a feature does for its users, why it exists, where it lives | `docs/map/<feature>.md` | edited in the same PR as the code; `ult-doccheck` checks its pointers |
| Who the product is for, the problem, concepts, scope, never | `docs/PRODUCT.md` | edited when the product changes |
| A decision that costs more than a PR to reverse | `docs/adr/NNNN-<slug>.md` | a dated record, never edited, superseded by a new one |
| Prior art and why we build | `docs/RESEARCH.md` | dated snapshot |
| Everything one piece of work needs: requirements, edge cases, decisions, done-check | its GitHub issue | consumed once, closed by its PR, then history |

- **Durable docs say why and what, never how.** `PRODUCT.md`, ADRs and the map hold no value, format, signature, threshold or step that the code holds. Point to the symbol or the test instead: "limits are enforced by `rateLimit`, see `src/limit.test.ts`", not "100 requests per minute". A sentence that would need editing when the code changes does not belong in a durable doc.
- **Issues copy in full.** An open issue is the one document its builder reads. It states every requirement, edge case, term and decision the work needs, written out, so it reads alone. It is safe to copy into an issue because the issue dies with its PR.
- **Code wins.** When a doc and the code disagree, the code says what is true. Fix the doc in the same PR, or, if the code is wrong, file an issue against it. A closed issue is never a reference: read the code.

## Write for an agent reading cold

Every later session reads these mid-task with no memory of the interview. Each rule exists because an agent does worse without it.

- **Fixed headings, in the template's order.** An agent looks for `## Scope`, not for wherever the author put it. Drop a section that has nothing true to say; never rename one.
- **The first line answers the doc.** One sentence: what it is and for whom.
- **One fact per bullet.** A bullet holding two facts gets half-read. No paragraphs except `Problem` and `Why`.
- **Stable ids.** Scenarios `S1`, requirements `R1`, edge cases `E1`, decisions `D1`. An id is never reused or renumbered; a dropped one stays as `R4 (dropped: <why>)`. Ids let parts, tests and the user name a line; they never replace its text in an issue.
- **Testable or it is not a requirement.** Each states observable behavior with its value and names its check. A line no check could fail goes to `Open` as a question.
- **One word per thing.** Use the terms in `PRODUCT.md` `Concepts` or the issue's `Terms`, never a synonym.
- **Unknowns are visible.** Undecided goes under `Open` with who answers it; believed without evidence goes under `Risks` as `unverified`. Never smooth a gap over with a plausible sentence.
- **Sized for one read.** Each template has a cap. A doc that outgrows it holds two concerns: split it.
- **No placeholders, no filler.** Concrete, in the product's words. A sentence that would fit any product says nothing about this one.

## Cold read

Every planning doc and issue draft is tested by `ult:goldfish` before the user sees it as final, because a doc only its author understands fails the next agent silently.

1. Send `ult:goldfish` the paths, nothing else, and the kind of each. Never your summary of the interview: that is the context the builder will not have. A sub-issue is read alone, one goldfish per part, in parallel: its builder will have that issue and the code, nothing else.
2. A finding the interview already settled means the doc failed to say it: fix the doc. A finding the interview did not settle is a question for the user, asked with the goldfish's wording and challenged like any other answer. Never fill a hole with your own guess.
3. A `PREMISE` finding is put to the user as an objection, the way [INTERVIEW.md](../grill-me/INTERVIEW.md) "Stance" says, and the answer goes under `Challenges` in `.ult/grill.md`.
4. Send a new `ult:goldfish` on each revised doc, with no word of the first round, so it judges the doc and not your fixes. At most two rounds. Whatever still stands goes under `Open` or `Risks`, and you tell the user it is there.

## docs/PRODUCT.md

At most 120 lines. It says what and why. How is in the ADRs and the code.

```markdown
# <Name>

<One sentence: what it is and who it is for.>

## Problem
<Who has it, when it happens, what they do today and what that costs them. Use the real story from the interview.>

## Users
- **<who>**: <their situation and what they want from this>
- Not for: <who, and why>

## Core loop
<who> does <action> and gets <result>.

## Concepts
- **<noun>**: <what it is in this product, its states, what it belongs to>

## Scenarios
- **S1 <name>**: <the steps as the user lives them, ending in the outcome>

## Scope
### First version
- **<capability>**: <the outcome a user gets>. Each line becomes one epic.
### Later
- <capability>: <why not now>
### Never
- <what it will not do>: <why>

## Quality bar
- <an observable signal that it works, with a number where one exists>
- Unacceptable: <the failure that must not happen>

## Risks
- <assumption the product rests on>: <how it will be tested | unverified>. Stop if: <kill signal>

## Open
- <question>: <who answers, before which epic>

## Decisions
- [0001 <title>](adr/0001-<slug>.md)
```

`Concepts` are the glossary: the terms the interview pinned, defined once. Later code, issues and the map use these words and no synonyms. `Risks` comes from the pre-mortem, the kill criteria and every contested decision. The `Quality bar` is a product promise, not a test threshold: the tests that enforce it live in the code.

## docs/adr/NNNN-slug.md

One decision per file, numbered from `0001`. An ADR earns a file when reversing the decision would cost more than one pull request: runtime, storage, data ownership, identity, hosting, sync model, license, a format users or other programs depend on. A library that one module hides does not.

```markdown
# <NNNN>. <The decision, as a statement>

Status: accepted | Date: <YYYY-MM-DD> | Decided by: <user | default>

## Context
<The forces: the product need (cite the PRODUCT.md section), the constraints, what research found.>

## Decision
<What we do, in one paragraph.>

## Options
- **<chosen>**: <why it fits>
- **<rejected>**: <why not>. <source url>

## Consequences
- <what becomes easy, what becomes hard, and what finding would make us revisit this>
```

An accepted ADR is never rewritten, so it cannot drift: it records what was decided on its date. To change a decision, write a new ADR and set the old one's status to `superseded by <NNNN>`.

## docs/RESEARCH.md

```markdown
# Research

Checked: <YYYY-MM-DD>

## Prior art
| Name | What it does | Where it falls short for us | Link |
| --- | --- | --- | --- |

## Standards
- <spec or established practice>: <how this product uses it>. <url>

## Borrowed
- <pattern or lesson we take>, from <source>

## Why build
<One paragraph: the gap this product fills that the prior art does not.>
```

## CLAUDE.md section

```markdown
## Product
Read `docs/PRODUCT.md` before planning a feature: who this is for, the terms to use and what the product will never do. `docs/map/` says what each feature does, why, and where it lives. Decisions in `docs/adr/` are settled; to change one, write a new ADR that supersedes it. The code and its tests are the truth for how anything works. An open issue is the full brief for its work; a closed one is history.
```
