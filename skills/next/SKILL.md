---
name: next
description: Say where the work stands and the one thing to do next, with the command to paste. Reads the task file, the branch and open pull requests. Use when resuming, after a break, or when asked what is next or left.
---

# Next

Answer "where am I and what do I do now" from recorded state, in a few lines. Change nothing.

## Read, in this order, and stop reading a source once it is empty

1. `.ult/task.md`: an unfinished task. The first unticked slice is the next step.
2. `git status --short --branch` and `git log --oneline -5`: uncommitted work, and a branch ahead of its remote.
3. `gh pr list --author "@me" --state open --json number,title,reviewDecision,statusCheckRollup`: pull requests waiting on checks, review or a merge.

## Pick the one next action, first match wins

1. A check is red on an open pull request: fix it.
2. Uncommitted changes: finish and commit them, or say what they are and ask.
3. An unticked slice in the task file: `/ult:ship` resumes it.
4. A pull request that is green and waiting only on the user: name it.
5. Nothing recorded: say so in one line. The later parts of a split feature are in the report that ended the last part, not on disk.

## Reply

```
Now: <branch and its state, in one line>
Open: <PR number, title, what it waits on>          (one line each, at most 3)
Next: <the one action> -> `<command to paste>`
Then: <the step after, at most 2 lines>
```

At most 8 lines. Report what the sources say; mark anything you inferred. If `gh` is missing or logged out, skip step 3 and say so.
