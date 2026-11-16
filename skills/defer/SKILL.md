---
name: defer
description: Open a GitHub issue for a problem that is real but outside the current task, instead of fixing it in this diff or leaving a marker in the code. Use when you notice a bug, debt or follow-up you will not handle now.
---

# Defer with an issue

A deferred problem lives in the tracker, where it can be found, ranked and closed. It never lives in a code comment or only in your reply.

1. Check it is not already filed: `gh issue list --search "<two or three keywords>" --state open`.
2. File it:

```bash
gh issue create --title "<area>: <the problem, stated as a fact>" --body "$(cat <<'EOF'
## What
<One or two sentences. What is wrong or missing.>

## Where
`path/to/file.ext:line` `symbol`

## Why it matters
<Who is affected and how. What breaks, or what it costs.>

## Evidence
<The command and output, or the input that shows it. Omit if none.>

## Suggested direction
<One or two lines if you have a concrete idea. Omit if not.>

Found while working on <branch or PR>.
EOF
)"
```

3. Add a label only if the repo already uses it (`gh label list`).
4. Go back to the task. Mention the issue number in your final report and in the PR if it relates.

## File an issue for

- a bug you found but did not cause and that the goal does not need fixed;
- a refactor that would help but would widen the diff;
- a missing test, a flaky test, a slow check;
- a decision you made by default that the user may want to revisit.

## Do not file

- something you can fix in under five lines inside the files you are already changing: fix it;
- a problem your own change introduced: fix it;
- a vague wish with no location and no consequence.

If `gh` is missing or not authenticated, list the deferred items under "Open issues to file" in your final report with the same fields. Never drop them.
