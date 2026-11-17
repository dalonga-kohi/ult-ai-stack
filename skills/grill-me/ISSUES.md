# Filing an epic and its parts

Issues cite the docs; they never copy them. A copied requirement goes stale the moment a later part changes the doc, and a fresh session builds from the stale copy. So a part names the ids it covers and the commit the docs were pinned at, and `ult:ship` reads the current doc and the diff since the pin.

Write every body to a file with the Write tool and pass it with `--body-file`. Drafts live in `.ult/epic/`; `ult:new`, which files several epics, uses one folder per epic, `.ult/epic/<e>/`, and the paths below are relative to it. This works in bash and PowerShell alike, and an inline quoted body does not. `gh issue create` prints the new issue's URL, and the number is its last segment.

## 1. Pin

The docs must be on the remote default branch before anything is filed: a pin to a local commit, or to a branch that a squash merge deletes, points at nothing. Run `git fetch origin`, then `git rev-parse --short=12 origin/HEAD` (or `origin/<default branch>` if `origin/HEAD` is unset). That hash is `<pin>` below.

## 2. Label

Run `gh label list --search epic`. If no `epic` label is listed, create it:

```
gh label create epic --description "Parent issue split into sub-issues by ult:grill-me or ult:new"
```

## 3. Parent

Write `.ult/epic/parent.md`, leaving `Parts` empty for now, then:

```
gh issue create --title "<area>: <the outcome, in a few words>" --label epic --body-file .ult/epic/parent.md
```

```markdown
## Outcome
<What a user can do once every part is done, in the product's words.>

Docs: `docs/specs/<slug>.md` @ <pin>
Contested: <D ids the user kept over an objection | none>

## Parts
- [ ] #<a> <title>
```

For an `ult:new` epic, `Docs` names `docs/PRODUCT.md` and the ADRs the epic rests on, and `Contested` names the `Risks` lines in `PRODUCT.md` that hold overruled objections. Decisions, terms and scope live in the docs, not here.

## 4. Sub-issues, in order

For each part, in order, run `gh issue create --title "<area>: <outcome of this part>" --body-file .ult/epic/<k>.md` on the draft written and cold-read earlier. Fill `#<parent>`, the numbers of earlier parts and `<pin>` into a draft before filing it.

```markdown
Part <k> of #<parent>: <parent title>

## Outcome
<One sentence a user or caller would say when it works.>

Docs: `docs/specs/<slug>.md` @ <pin>
Covers: R1, R3, E2
Rests on: D2, D5, ADR 0003

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

`Done when` becomes the goal contract when `ult:ship` picks the issue up, so write checks that fail today, at least one per covered id. Before you file a part, run its `Done when` command and confirm it fails or does not yet exist.

`Covers` lists the `R` and `E` ids this part delivers; `Rests on` lists the decisions (`D`) and ADRs it must respect without delivering them. For an `ult:new` part, `Docs` is `docs/PRODUCT.md` and its ADRs, `Covers` names the `S` scenarios and the `Scope` capability, and `Rests on` the ADRs. Ids only, never their text: the doc at the pin is the text.

## 5. Link

Each sub-issue is linked to the parent by its id, which is not its number:

```
gh api "repos/{owner}/{repo}/issues/<child number>" --jq .id
gh api "repos/{owner}/{repo}/issues/<parent number>/sub_issues" -F sub_issue_id=<id>
```

Then fill in `Parts` in `.ult/epic/parent.md` and run `gh issue edit <parent> --body-file .ult/epic/parent.md`. Delete `.ult/epic/` once everything is filed. The checklist stays even when linking works: it is the fallback when the host has no sub-issues API, and GitHub shows each item's state next to it. If the link call fails, keep the checklist and say in the report that the sub-issues are unlinked.
