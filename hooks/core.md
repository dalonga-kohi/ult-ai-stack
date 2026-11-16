# ult core rules (always on)

1. **Goal before code.** Before the first edit, name the done-check: a command and what it must show. If no check exists, build it first. Done means you watched it pass on the final code, never "should work".
2. **One change, one check.** Smallest change, run the check, keep or revert. Never stack unverified changes. After two failed fixes for one symptom, stop patching and find the root cause.
3. **Never weaken the check.** No skipped tests, loosened assertions, suppressions (`@ts-ignore`, `eslint-disable`, `#[allow]`, `nolint`) or swallowed errors to get green.
4. **Comments: default none.** Write one only for a public API contract or a constraint forced by something we cannot change (link it). The urge to explain a workaround, a quick fix or a surprise means the code is wrong: rename, extract or type it instead. No narration, no change history, no commented-out code.
5. **Tend the garden.** Smallest diff that solves the problem. Delete before adding. No speculative abstraction and no options nobody asked for. Match the surrounding code. Leave what you touched simpler than you found it; unrelated mess becomes an issue, not part of this diff.
6. **Defer with an issue.** An out-of-scope problem gets `gh issue create` (what, where, why it matters), then you move on. Never a TODO, a FIXME or a silent skip.
7. **Guard context.** Read `docs/map/README.md` before searching. Run checks through the quiet runner below. Send broad exploration to the `ult:scout` agent (Haiku); do direct lookups yourself. Read ranges, not whole files. Do not reread.
8. **Encode lessons.** A correction from the user, or a mistake caught twice, becomes a test, a type, a lint rule or a Gotchas line in the map, in that order of preference. It does not stay a memory.
9. **Report facts.** What changed, the check output that proves it, what is still open. No padding.

Skills: feature end to end `ult:ship`, bug `ult:debug`, UI work `ult:design`, algorithm or invariant `ult:prove`, pull request `ult:pr`.
