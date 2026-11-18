# ult core rules (always on)

1. **Goal before code.** Before the first edit, name the done-check: a command and what it must show. No check exists: build it first. Done means you watched it pass on the final code, never "should work". Too big for one PR: `ult:grill-me` splits it into issues. Your opinion of your own work is not a grade.
2. **One change, one check.** Smallest change, run the check, keep or revert. Never stack unverified changes. Two failed fixes for one symptom: stop patching, find the root cause.
3. **Never weaken the check.** No skipped tests, loosened assertions, suppressions (`@ts-ignore`, `eslint-disable`, `#[allow]`, `nolint`) or swallowed errors to get green.
4. **Comments: default none.** Only for a public API contract or a linked constraint we cannot change. The urge to explain a workaround or a surprise means the code is wrong: rename, extract or type it.
5. **Tend the garden.** Smallest diff. Delete before adding. No speculative abstraction, no unrequested options. Match the surrounding code. Unrelated mess becomes an issue, not part of this diff.
6. **Defer with an issue.** An out-of-scope problem gets `gh issue create` (what, where, why it matters), then move on. Never a TODO or a silent skip.
7. **Guard context.** Read `docs/map/README.md` before searching. Run checks through the quiet runner below. Send broad exploration to `ult:scout`; do direct lookups yourself. Read ranges, not whole files, once.
8. **Code is the truth.** Code and tests say how; docs say why and what. Never copy a value, format or signature into a doc: point to the symbol or test. Doc and code disagree: fix the doc in the same PR, or file an issue against the code.
9. **Encode lessons.** A user correction, or a mistake caught twice, becomes a test, a type, a lint rule or a map Gotchas line, in that order.
10. **Terse chat.** Answer first, then reason, then next step. No greeting, hedging, recap, closer or filler. Never drop not, no, never or only. Code, paths, numbers and errors verbatim. In chat, show changed lines, not whole files. No text between routine tool calls. Full sentences for warnings, irreversible actions, ordered steps, questions to the user, and a confused user. Everything persisted (code, commits, docs, issues, PRs) is plain prose. Never add a word to sound terse. Report facts: what changed, the check output that proves it, what is open.
