# Filing an epic and its parts

The issues are the plan. Each sub-issue is the whole brief for one fresh session: that session reads the issue and the code, and nothing else, so the issue states every requirement, edge case, term and decision its part needs, in full. Copying is safe here because an issue is consumed once: its PR closes it, and from then on the code and its tests are the truth. A link to another doc is background, never a substitute for a line the builder needs.

Write every body to a file with the Write tool and pass it with `--body-file`. Drafts live in `.ult/epic/`; `ult:new`, which files several epics, uses one folder per epic, `.ult/epic/<e>/`, and the paths below are relative to it. This works in bash and PowerShell alike, and an inline quoted body does not. `gh issue create` prints the new issue's URL, and the number is its last segment.

## 1. Label

Run `gh label list --search epic`. If no `epic` label is listed, create it:

```
gh label create epic --description "Parent issue split into sub-issues by ult:grill-me or ult:new"
```

## 2. Parent

The parent holds the whole record of the interview, so the user and every part can see what was decided and why. At most 150 lines. Write `.ult/epic/parent.md`, leaving `Parts` empty for now, then:

```
gh issue create --title "<area>: <the outcome, in a few words>" --label epic --body-file .ult/epic/parent.md
```

```markdown
## Outcome
<What a user can do once every part is done, in the product's words.>

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
- **D1** <decision> [user | default | user, contested]: <reason>. Rejected: <option>: <why not>

## Out of scope
- <item>: <why, and where it went: later, never, #issue>

## Risks
- <assumption or overruled objection>: <how it will be tested | unverified>. Stop if: <kill signal>

## Parts
- [ ] #<a> <title>: R1, R2, E1
```

For an `ult:new` epic, `Why` cites the `Problem` and `Scope` line of `docs/PRODUCT.md` it delivers, and `Requirements` are what the capability must do, derived from its scenarios.

## 3. Sub-issues, in order

At most 100 lines each; a part that needs more is two parts. For each part, in order, run `gh issue create --title "<area>: <outcome of this part>" --body-file .ult/epic/<k>.md` on the draft written and cold-read earlier. Fill `#<parent>` and the numbers of earlier parts into a draft before filing it.

```markdown
Part <k> of #<parent>: <parent title>

## Outcome
<One sentence a user or caller would say when it works.>

## Why
<Two or three sentences: the problem this part moves, for whom, so a builder can make the small calls the issue does not.>

## Requirements
- **R1** <the full requirement, with its value>. Check: <how it is proven>
- **E2** <the full edge case>: <what happens>

## Decisions
- **D2** <the decision this part must respect, in full>: <the reason, in one line>
- **ADR 0003** <the decision, in one line>. Background: `docs/adr/0003-<slug>.md`

## Terms
- **<term>**: <meaning>, for every term the requirements use

## Context
- <where the change lands: `path` `symbol`, map feature files>
- <what earlier parts built that this one uses: #<n> `path`>

## Done when
- `<command>` -> <what it must show>
- <behavior observed in the real app>

## Not in this part
- <what neighboring parts do, so this one does not grow into them>

Blocked by: <#n, #m | none>
Needs you: <the decision or access only the user can give | no>
```

`Requirements` carries every `R` and `E` this part delivers, written out; the ids match the parent so the user can trace them. `Decisions` carries every decision and ADR the part must respect, restated in one line each. A decision that is a new ADR is drafted in full under `Context`, and the part adds it to `docs/adr/`.

`Done when` becomes the goal contract when `ult:ship` picks the issue up, so write checks that fail today, at least one per requirement. Before you file a part, run its `Done when` command and confirm it fails or does not yet exist.

## 4. Link

Each sub-issue is linked to the parent by its id, which is not its number:

```
gh api "repos/{owner}/{repo}/issues/<child number>" --jq .id
gh api "repos/{owner}/{repo}/issues/<parent number>/sub_issues" -F sub_issue_id=<id>
```

Then fill in `Parts` in `.ult/epic/parent.md` and run `gh issue edit <parent> --body-file .ult/epic/parent.md`. Delete `.ult/epic/` once everything is filed. The checklist stays even when linking works: it is the fallback when the host has no sub-issues API, and GitHub shows each item's state next to it. If the link call fails, keep the checklist and say in the report that the sub-issues are unlinked.

## 5. When a decision changes later

A requirement or decision changed after filing, by the user or because the code made it impossible, is edited into the parent and into every open part that carries it, with `gh issue view <n> --json body --jq .body` to a file, the edit, then `gh issue edit <n> --body-file`. Add one line at the end of each edited body: `Changed <YYYY-MM-DD>: <id> <what and why>`. Closed parts are history and stay as they were; the code they shipped is the truth.
