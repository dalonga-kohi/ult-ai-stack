# Product docs

Templates for `ult:new`, which writes them, and for `ult:grill-me`, which adds ADRs. These docs are read cold by every later session, so write for a reader who never saw the interview: concrete, in the product's words, no placeholders. Drop a section that has nothing true to say.

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
1. **<name>**: <the steps as the user lives them, ending in the outcome>

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
- <assumption the product rests on>: <how it will be tested | unverified>

## Decisions
- [0001 <title>](adr/0001-<slug>.md)
```

`Concepts` are the glossary: the terms the interview pinned, defined once. Later code, issues and map use these words and no synonyms. `Risks` comes from the pre-mortem.

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
Read `docs/PRODUCT.md` before planning a feature: it says who this is for, the terms to use and what the product will never do. Decisions in `docs/adr/` are settled. To change one, write a new ADR that supersedes it.
```
