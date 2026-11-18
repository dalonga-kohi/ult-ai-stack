# ult-ai-stack

A Claude Code plugin (`ult`): skills, subagents and hooks. No build step. Design rationale is in `README.md`.

## Layout

- `hooks/core.md`: the always-on rules, injected at session start. Every line costs tokens in every session.
- `skills/<name>/SKILL.md`: loaded on demand. Sibling `.md` files are loaded only when the skill points to them.
- `skills/grill-me/INTERVIEW.md`: the interview technique and its adversarial stance, shared by `grill-me` and `new`. `skills/new/DOCS.md`: where each kind of fact lives (code is the truth for how; durable docs say why and what; issues carry the full brief and die with their PR), the rules for agent-readable docs, the cold read, and the `PRODUCT.md`, `RESEARCH.md` and ADR templates. `skills/grill-me/ISSUES.md`: the self-contained epic and sub-issue templates.
- `skills/design/tells.txt`: one regex per line for `rg -i -f`, the mechanical subset of `SLOP.md` and `COPY.md`. No blank lines (a blank pattern matches everything) and only high-precision patterns: a noisy scan gets ignored.
- `bin/ult-run` and `bin/ult-run.ps1`: the quiet check runner. One line on success, the tail on failure, full log in `.ult/logs/`.
- `bin/ult-doccheck` and `bin/ult-doccheck.ps1`: the drift check for `docs/map/`. Every backticked root-relative path must exist, a symbol right after a file path must occur in that file, and every relative link must resolve. One `BROKEN` line per failure.
- `agents/<name>.md`: subagents. `scout`, `verifier` and `design-scout` run on Haiku; `researcher`, `reviewer`, `critic` and `goldfish` on Sonnet. `goldfish` has only the `Read` tool, so it can see nothing but the docs it is handed; `scripts/check.sh` enforces that. The two graders share one scale block, kept identical by `scripts/check.sh`; bump the rubric version (`code/2`, `ui/1`) when a dimension or the scale changes, because scores do not compare across versions.

## Writing rules for this repo

- Budgets: `hooks/core.md` at most 450 words. A skill description at most 45 words. A `SKILL.md` at most 90 lines; move reference material to a sibling file behind a pointer that says when to read it.
- Write for an agent reading cold, mid-task. Steps are imperative and each ends in something observable. State a rule once, in the one place it belongs.
- A rule earns its place only if an agent would do worse without it. Do not add advice a capable model already follows.
- Every subagent defines an exact reply shape with a size cap. The reply is the only thing that reaches the main context.
- Linux, macOS and Windows are all targets. Every `.sh` in `hooks/` and `bin/` has a `.ps1` twin with the same behavior and the same tests in `scripts/check.sh`. PowerShell code must run on Windows PowerShell 5.1: ASCII only, no `&&`, `||`, `??` or ternary. Shell snippets in skills must run unchanged in bash and PowerShell; pass long text through a file (`--body-file`), never a heredoc.
- Each command in `hooks/hooks.json` is one line that both `sh` and PowerShell accept. `sh` runs the part before `#>` and treats the rest as a comment; PowerShell treats `<# ... #>` as a comment and runs the rest. Claude Code picks the shell: `sh`, Git Bash on Windows, or PowerShell when Git Bash is absent.
- Text adapted from another project is listed in `CREDITS.md`.

## Checks

- full: `bash scripts/check.sh` (on Windows, from Git Bash; it tests the `.ps1` files when `pwsh` or `powershell` is on the PATH, and CI runs it on Ubuntu and Windows)
