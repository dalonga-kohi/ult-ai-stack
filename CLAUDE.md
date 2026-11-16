# ult-ai-stack

A Claude Code plugin (`ult`): skills, subagents and hooks. No build step. Design rationale is in `README.md`.

## Layout

- `hooks/core.md`: the always-on rules, injected at session start. Every line costs tokens in every session.
- `skills/<name>/SKILL.md`: loaded on demand. Sibling `.md` files are loaded only when the skill points to them.
- `bin/ult-run`: the quiet check runner. One line on success, the tail on failure, full log in `.ult/logs/`.
- `agents/<name>.md`: subagents. `scout`, `verifier` and `design-scout` run on Haiku; `reviewer` on Sonnet.

## Writing rules for this repo

- Budgets: `hooks/core.md` at most 350 words. A skill description at most 45 words. A `SKILL.md` at most 90 lines; move reference material to a sibling file behind a pointer that says when to read it.
- Write for an agent reading cold, mid-task. Steps are imperative and each ends in something observable. State a rule once, in the one place it belongs.
- A rule earns its place only if an agent would do worse without it. Do not add advice a capable model already follows.
- Every subagent defines an exact reply shape with a size cap. The reply is the only thing that reaches the main context.
- Text adapted from another project is listed in `CREDITS.md`.

## Checks

- full: `bash scripts/check.sh`
