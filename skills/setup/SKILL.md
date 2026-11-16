---
name: setup
description: Prepare a repository for the ult workflow, once per repo. Records the check commands, creates the feature map and confirms GitHub access.
disable-model-invocation: true
---

# Setup

Run once per repository. Each step ends in something you can observe. Report at the end what was created, what already existed and what needs the user.

1. **Tools.** Run `gh auth status` and `git remote -v`. If `gh` is missing or logged out, tell the user the exact command to fix it (`gh auth login`) and continue; steps 5 and 6 then wait for them.

2. **Find the checks.** Read the manifest and CI config (`package.json` scripts, `Cargo.toml`, `go.mod`, `Makefile`, `justfile`, `.github/workflows/`). Work out two commands and run each to confirm it works:
   - `fast`: typecheck, lint and the quick tests. It should finish in under a minute and print little on success.
   - `full`: everything CI runs, including the complete test suite and the build.

   Record a command that runs unchanged in bash and PowerShell: a package script or task runner target (`npm run check`, `cargo test`, `just check`), not a pipeline or an `&&` chain. If only a chain exists, add the script.

   Prefer quiet flags so success is a few lines (`--silent`, `--reporter=dot`, `-q`, `--quiet`). If the repo has no tests or no linter, do not add one silently: record what exists and open an issue with `ult:defer` for what is missing.

3. **Record them** in the repo's `CLAUDE.md` (create it if absent; keep everything else in it unchanged):

   ```markdown
   ## Checks
   - fast: `<command>`
   - full: `<command>`
   - run: `<command that starts the app, if any>`
   ```

4. **Feature map.** If `docs/map/README.md` is absent, create the map with the `ult:map` skill.

5. **CI.** If no workflow runs the `full` check on pull requests, propose a minimal one and add it only if the user agrees. Auto-merge needs CI; without it every PR waits for the user.

6. **Auto-merge.** Check `gh repo view --json autoMergeAllowed,defaultBranchRef`. If auto-merge is off, tell the user it can be enabled with `gh repo edit --enable-auto-merge` and that required status checks on the default branch make it safe. Do not change repository settings yourself.

7. **Ignore file.** Add `.ult/` to `.gitignore` (scratch space for logs and measurements).

8. **Commit** the `CLAUDE.md`, map and `.gitignore` changes on a branch and open a PR with `ult:pr`.
