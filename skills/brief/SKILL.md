---
name: brief
description: Write the prompt for another agent, or turn a rough request into one. Covers the goal, the context the reader lacks, the done-check, the limits and the reply shape. Use before spawning a subagent or when asked to sharpen a prompt.
argument-hint: <rough request>
---

# Brief

The reader of a brief starts with nothing: no conversation, no files read, no idea what was already tried. Everything it needs to do the job well is in the brief or it is missing. Most poor agent output traces to a brief that left out what the writer knew.

## What a brief holds

```
Goal: <the outcome, and what it is for>
Context: <what the reader cannot find out alone>
Done when: `<command>` -> <observation>
Limits: <what not to touch, what needs asking first>
Reply: <the exact shape, with a size cap>
```

- **Goal, with its purpose.** "Find where sessions expire" gets a file list. "Find where sessions expire; users are logged out after ten minutes and the setting says an hour" gets the cause. The purpose tells the reader what to optimize and when to stop.
- **Context it cannot discover.** Paths and symbols, decisions already made, approaches already ruled out and why, the part that is harder than it looks. Give paths, not pasted files: the reader can open them.
- **A done-check.** A command and what it must show. Without one the reader stops when the work looks finished.
- **Limits.** The scope, the files that stay untouched, the actions that need a question first.
- **A reply shape with a cap.** The reply is all that comes back. Ask for the conclusion first, locations as `path:line`, and what was verified kept apart from what was inferred.

## Rules

- **One job per brief.** Two jobs get two briefs, or the second is done badly.
- **Say what to do.** "Return at most 10 lines" works. "Do not be verbose" names the thing to avoid and nothing to aim at.
- **Give the reason beside the rule.** A reader that knows why applies the rule to the cases you did not list. A bare rule is followed rigidly or dropped.
- **Do not lead a judge.** A reviewer or grader gets the subject and the standard. Never your conclusion, your hopes or what you fixed.
- **Match the length to the job.** A lookup needs three lines. A design task needs the constraints and the rejected options. Padding buries the instruction that matters.
- **No emphasis, no threats.** Capitals and "critical" make a reader over-apply one rule and neglect the rest. State it once, plainly.
- **Read it as the reader.** Before sending, read the brief as someone who knows nothing else. Every question you would have to ask is a missing line.

## On request

`/ult:brief <rough request>`: read enough of the repo to fill `Context` and `Done when` with real paths and a real command, then print the brief ready to paste, usually as a `/ult:ship` request. Ask only when the request has two readings that lead to different products. Build nothing.
