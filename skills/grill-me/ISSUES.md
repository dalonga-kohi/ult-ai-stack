# Filing an epic and its parts

Write every body to a file with the Write tool and pass it with `--body-file`. This works in bash and PowerShell alike, and an inline quoted body does not. `gh issue create` prints the new issue's URL, and the number is its last segment.

## 1. Label

Run `gh label list --search epic`. If no `epic` label is listed, create it:

```
gh label create epic --description "Parent issue split into sub-issues by ult:grill-me or ult:new"
```

## 2. Parent

Write `.ult/epic.md`, leaving `Parts` empty for now, then:

```
gh issue create --title "<area>: <the outcome, in a few words>" --label epic --body-file .ult/epic.md
```

```markdown
## Outcome
<What a user can do once every part is done, in the product's words.>

## Decisions
- <question> -> <answer>. <reason, when it is not obvious>

## Terms
- **<term>**: <what it means in this product>

## Out of scope
- <what was struck or deferred, and why>

## Parts
- [ ] #<a> <title>
```

Omit `Terms` when there are none.

## 3. Sub-issues, in order

For each part, write `.ult/issue.md` and run `gh issue create --title "<area>: <outcome of this part>" --body-file .ult/issue.md`.

```markdown
Part <k> of #<parent>: <parent title>

## Outcome
<One sentence a user or caller would say when it works.>

## Context
- <each decision from the parent that this part depends on, restated in full>
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

`Done when` becomes the goal contract when `ult:ship` picks the issue up, so write checks that fail today. Before you file a part, run its `Done when` command and confirm it fails or does not yet exist.

## 4. Link

Each sub-issue is linked to the parent by its id, which is not its number:

```
gh api "repos/{owner}/{repo}/issues/<child number>" --jq .id
gh api "repos/{owner}/{repo}/issues/<parent number>/sub_issues" -F sub_issue_id=<id>
```

Then fill in `Parts` in `.ult/epic.md` and run `gh issue edit <parent> --body-file .ult/epic.md`. The checklist stays even when linking works: it is the fallback when the host has no sub-issues API, and GitHub shows each item's state next to it. If the link call fails, keep the checklist and say in the report that the sub-issues are unlinked.
