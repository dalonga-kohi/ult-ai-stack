# Planning docs

Templates for `ult:new` (`PRODUCT.md`, `RESEARCH.md`, ADRs) and `ult:grill-me` (specs, ADRs), the rules every one of them follows, and the cold read that tests them. Read the rules before writing any of them.

## Write for an agent reading cold

These docs are read by every later session, mid-task, with no memory of the interview. Each rule exists because an agent does worse without it.

- **Fixed headings, in the template's order.** An agent looks for `## Requirements`, not for wherever the author put them. Drop a section that has nothing true to say; never rename one.
- **The first line answers the doc.** One sentence: what it is and for whom. A reader that needs only that stops there.
- **One fact per bullet.** A bullet holding two facts gets half-read. No paragraphs except `Problem` and `Why`.
- **Stable IDs.** Requirements are `R1`, `R2`, edge cases `E1`, scenarios `S1`. An ID is never reused or renumbered; a dropped one stays as `R4 (dropped: <why>)`. Issues, tests and later docs cite the ID.
- **Testable or it is not a requirement.** Each states observable behavior with its value ("exports in under 2 s for 1,000 rows") and names its check. A line no check could fail goes to `Open` as a question.
- **One word per thing.** Use the terms in `PRODUCT.md` `Concepts` or the doc's `Terms`, never a synonym.
- **Point, do not copy.** Link the ADR or the other doc's section instead of restating it. Issues are the one exception: they restate, because they must stand alone.
- **Unknowns are visible.** What is undecided goes under `Open` with who answers it; what is believed without evidence goes under `Risks` as `unverified`. Never smooth a gap over with a plausible sentence.
- **Sized for one read.** Each template has a cap. A doc that outgrows it holds two concerns: split it and link the halves.
- **No placeholders, no filler.** Concrete, in the product's words. A sentence that would fit any product says nothing about this one.

## Cold read

Every planning doc is tested by `ult:goldfish` before the user sees it as final, because a doc only its author understands fails the next agent silently.

1. Send `ult:goldfish` the paths of the docs, nothing else, and the kind of each. Never your summary of the interview: that is the context the builder will not have.
2. A finding the interview already settled means the doc failed to say it: fix the doc. A finding the interview did not settle is a question for the user, asked with the goldfish's wording and challenged like any other answer. Never fill a hole with your own guess.
3. A `PREMISE` finding is put to the user as an objection, the way [INTERVIEW.md](../grill-me/INTERVIEW.md) "Stance" says, and the answer goes under `Challenges` in `.ult/grill.md`.
4. Send a new `ult:goldfish` on the revised docs, with no word of the first round, so it judges the docs and not your fixes. At most two rounds. Whatever still stands goes under `Open` or `Risks` in the doc, and you tell the user it is there.

## docs/PRODUCT.md

At most 120 lines. It says what and why. How is in the ADRs and, later, the code.

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

`Concepts` are the glossary: the terms the interview pinned, defined once. Later code, issues and map use these words and no synonyms. `Risks` comes from the pre-mortem, the kill criteria and every contested decision.

## docs/specs/slug.md

One per feature that went through `ult:grill-me`, at most 150 lines. It says what the feature does and why, precisely enough to write the tests from. The epic and its parts are the work; the spec is the reference they all cite, and it outlives them.

```markdown
# <Feature>

<One sentence: who gets what.>

Status: agreed | shipped | Epic: #<n> | Product: [<section>](../PRODUCT.md#<anchor>)

## Why
<The problem, the real instance from the interview, what it costs today, why now.>

## Scenarios
- **S1 <name>**: <the steps as the user lives them, ending in the outcome>

## Requirements
- **R1** <observable behavior, with its value>. Check: <command or behavior that proves it>. [user | default]

## Edge cases
- **E1** <empty, invalid, failed dependency, wrong user, concurrent, existing data, largest size, undo>: <what happens>

## Terms
- **<term>**: <meaning in this feature>

## Decisions
- <decision> [user | default | user, contested]: <reason>. Rejected: <option>: <why not>

## Out of scope
- <item>: <why, and where it went: later, never, #issue>

## Risks
- <assumption or overruled objection>: <how it will be tested | unverified>. Stop if: <kill signal>

## Open
- <question>: <who answers, before which part>

## Parts
| Part | Issue | Covers | After |
| --- | --- | --- | --- |
| 1 <title> | #<n> | R1, R2, E1 | - |
```

Every `R` and `E` appears in exactly one part's `Covers`. When a part ships and the behavior differs from the spec, that part's PR updates the line: the spec describes the product as it is, not as it was planned.

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

An accepted ADR is never rewritten. To change a decision, write a new ADR and set the old one's status to `superseded by <NNNN>`.

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
Read `docs/PRODUCT.md` before planning a feature: it says who this is for, the terms to use and what the product will never do. A feature with a spec in `docs/specs/` is defined there; cite its `R` and `E` ids. Decisions in `docs/adr/` are settled. To change one, write a new ADR that supersedes it.
```
