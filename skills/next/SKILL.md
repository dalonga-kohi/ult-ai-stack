---
name: next
description: Say where the work stands and the one thing to do next, with the command to paste. Reads the task file, the branch, open pull requests and open epics. Use when resuming, after a break, or when asked what is next or left.
---

# Next

Answer "where am I and what do I do now" from recorded state, in a few lines. Change nothing.

## Read, in this order, and stop reading a source once it is empty

1. `.ult/task.md`: an unfinished task. The first unticked slice is the next step.
2. `git status --short --branch` and `git log --oneline -5`: uncommitted work, and a branch ahead of its remote.
3. `gh pr list --author "@me" --state open --json number,title,reviewDecision,statusCheckRollup`: pull requests waiting on checks, review or a merge.
4. `gh issue list --label epic --state open --json number,title`: epics from `ult:grill-me`. For each one, list its parts with `gh api "repos/{owner}/{repo}/issues/<n>/sub_issues" --jq ".[] | [.number, .state, .title] | @tsv"`, or read the `Parts` checklist in its body if that call fails. Read the `Blocked by` line of the open parts only.

## Pick the one next action, first match wins

1. A check is red on an open pull request: fix it.
2. Uncommitted changes: finish and commit them, or say what they are and ask.
3. An unticked slice in the task file: `/ult:ship` resumes it.
4. A pull request that is green and waiting only on the user: name it.
5. An open part of an epic whose blockers are all closed, first in the epic's order: `/ult:ship #<number>` in a new session (/clear).
6. An epic whose parts are all closed: close it with `gh issue close <number>`.
7. Nothing recorded: say so in one line.

## Reply

```
Now: <branch and its state, in one line>
Open: <PR number, title, what it waits on>          (one line each, at most 3)
Next: <the one action> -> `<command to paste>`
Then: <the step after, at most 2 lines>
```

At most 8 lines. Report what the sources say; mark anything you inferred. If `gh` is missing or logged out, skip steps 3 and 4 and say so.
