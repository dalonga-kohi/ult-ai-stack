#!/usr/bin/env bash
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root" || exit 1
fail=0
err() { echo "FAIL $*"; fail=1; }

py=$(command -v python3 || command -v python) || { echo "FAIL python is required"; exit 1; }
ps=${ULT_PS:-$(command -v pwsh || command -v powershell || true)}
if [ -z "$ps" ] && [ -n "${ULT_REQUIRE_PS:-}" ]; then err "PowerShell is required (ULT_REQUIRE_PS) and was not found"; fi

for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json hooks/hooks.json; do
  "$py" -m json.tool "$f" >/dev/null 2>&1 || err "$f: invalid JSON"
done

for f in hooks/*.sh scripts/*.sh bin/ult-run; do
  bash -n "$f" || err "$f: syntax"
done

for f in hooks/*.sh bin/ult-run; do
  [ -f "${f%.sh}.ps1" ] || err "$f: no PowerShell twin ${f%.sh}.ps1"
done

words=$(wc -w < hooks/core.md)
[ "$words" -le 350 ] || err "hooks/core.md: $words words, budget 350"

for f in skills/*/SKILL.md agents/*.md; do
  name=$(awk '/^---$/{n++; next} n==1 && /^name:/{sub(/^name:[ ]*/, ""); print}' "$f")
  desc=$(awk '/^---$/{n++; next} n==1 && /^description:/{sub(/^description:[ ]*/, ""); print}' "$f")
  expected=$(basename "$(dirname "$f")")
  case "$f" in agents/*) expected=$(basename "$f" .md) ;; esac
  [ "$name" = "$expected" ] || err "$f: name '$name' does not match '$expected'"
  [ -n "$desc" ] || err "$f: no description"
  dw=$(printf '%s' "$desc" | wc -w)
  [ "$dw" -le 45 ] || err "$f: description is $dw words, budget 45"
done

for f in skills/*/SKILL.md; do
  lines=$(wc -l < "$f")
  [ "$lines" -le 90 ] || err "$f: $lines lines, budget 90"
done

while IFS=: read -r file target; do
  [ -f "$(dirname "$file")/$target" ] || err "$file: broken link $target"
done < <(grep -oH '\]([A-Z][A-Z_-]*\.md)' skills/*/*.md README.md 2>/dev/null | sed -E 's/\]\((.*)\)$/\1/')

if grep -nE '\$\(cat <<|<<-?.?EOF' skills/*/*.md agents/*.md; then
  err "skills and agents must not use heredocs: they do not run in PowerShell"
fi

scale() { grep -E '^(90-100|75-89|60-74|40-59|0-39) ' "$1"; }
[ "$(scale agents/reviewer.md | wc -l)" -eq 5 ] || err "agents/reviewer.md: the grading scale needs 5 bands"
[ "$(scale agents/reviewer.md)" = "$(scale agents/critic.md)" ] || err "agents/reviewer.md and agents/critic.md: the grading scale differs"

tells_cases() {
  local tells=skills/design/tells.txt tmp hits
  if grep -q '^$' "$tells"; then err "$tells: a blank line matches every line"; return; fi
  tmp=$(mktemp -d)
  grep -v '^\\p{' "$tells" > "$tmp/ere"
  cat > "$tmp/slop.tsx" <<'SLOP'
<h1 className="bg-clip-text text-transparent">x</h1>
<div className="bg-gradient-to-r from-purple-500 to-pink-500" />
<div className="hover:scale-105" />
<div className="transition-all" />
<div className="backdrop-blur-md" />
<a href="#">Pricing</a>
<p>Lorem ipsum dolor</p>
<p>John Doe, Acme Inc</p>
<title>Vite + React</title>
<p>A seamless way to work</p>
<h2>Supercharge your workflow</h2>
<p>Blazing fast and all-in-one</p>
<p>Take your team to the next level</p>
<p>Oops! Something went wrong</p>
SLOP
  cat > "$tmp/clean.tsx" <<'CLEAN'
<a href="/pricing">See pricing</a>
<div className="transition-colors from-stone-100 to-stone-200 blur-sm" />
<button>Delete 3 invoices</button>
<p>Cold start in 40 ms. Send invoices from your terminal.</p>
<p>This deletes 3 invoices and cannot be undone.</p>
CLEAN
  hits=$(grep -E -i -c -f "$tmp/ere" "$tmp/slop.tsx")
  [ "$hits" -eq 14 ] || err "$tells: matched $hits of 14 slop lines"
  hits=$(grep -E -i -c -f "$tmp/ere" "$tmp/clean.tsx")
  [ "$hits" -eq 0 ] || err "$tells: matched $hits clean lines"
  if command -v rg >/dev/null 2>&1; then
    hits=$(rg -i -c -f "$tells" "$tmp/slop.tsx")
    [ "$hits" -eq 14 ] || err "$tells under rg: matched $hits of 14 slop lines"
    rg -i -q -f "$tells" "$tmp/clean.tsx" && err "$tells under rg: matched a clean line"
  fi
  rm -rf "$tmp"
}
tells_cases

guard_cases() {
  local label=$1 tmp; shift
  tmp=$(mktemp -d)
  (
    cd "$tmp" && git init -q && git config user.email t@t && git config user.name t && git config core.autocrlf false
    echo "const a = 1;" > a.ts && git add a.ts && git commit -qm init
    export CLAUDE_PROJECT_DIR="$tmp"

    echo "const b = 2;" >> a.ts && git add a.ts
    "$@" </dev/null 2>/dev/null || { echo "FAIL $label blocked a clean diff"; exit 1; }

    printf '// TO%s: later\n' "DO" >> a.ts && git add a.ts
    "$@" </dev/null 2>/dev/null; [ $? -eq 2 ] || { echo "FAIL $label passed a deferral marker"; exit 1; }
    git reset -q --hard

    printf '// @ts-ig%s\n' "nore" >> a.ts
    "$@" </dev/null 2>/dev/null; [ $? -eq 2 ] || { echo "FAIL $label passed an unstaged suppression"; exit 1; }
    git reset -q --hard

    printf '// @ts-expect-er%s vendor bug, see #12\n' "ror" >> a.ts && git add a.ts
    "$@" </dev/null 2>/dev/null || { echo "FAIL $label blocked a line that references an issue"; exit 1; }
    git reset -q --hard

    printf '#[al%s(dead_code)]\nfn a() {}\n' "low" > a.rs && git add a.rs
    "$@" </dev/null 2>/dev/null; [ $? -eq 2 ] || { echo "FAIL $label passed a Rust lint suppression"; exit 1; }
    git reset -q --hard

    echo '{"tool_input":{"command":"git commit --no-verify -m x"}}' | "$@" 2>/dev/null
    [ $? -eq 2 ] || { echo "FAIL $label passed --no-verify"; exit 1; }

    printf 'TO%s list\n' "DO" > notes.md && git add notes.md
    "$@" </dev/null 2>/dev/null || { echo "FAIL $label scanned markdown"; exit 1; }
  ) || fail=1
  rm -rf "$tmp"
}

runner_cases() {
  local label=$1 pass=$2 failing=$3 tmp out code; shift 3
  tmp=$(mktemp -d)
  out=$(CLAUDE_PROJECT_DIR="$tmp" "$@" "$pass"); code=$?
  { [ $code -eq 0 ] && [ "$(printf '%s\n' "$out" | wc -l)" -eq 1 ] && [[ $out == PASS* ]]; } || err "$label: a passing command should print one PASS line, got exit $code: $out"
  out=$(CLAUDE_PROJECT_DIR="$tmp" ULT_TAIL=5 "$@" "$failing"); code=$?
  { [ $code -eq 3 ] && [ "$(printf '%s\n' "$out" | wc -l)" -eq 6 ] && [[ $out == FAIL* ]]; } || err "$label: a failing command should keep its exit code and print the tail, got exit $code: $out"
  out=$(CLAUDE_PROJECT_DIR="$tmp" "$@" echo two words); [[ $out == PASS* ]] || err "$label: argv form failed: $out"
  rm -rf "$tmp"
}

session_case() {
  local label=$1 out; shift
  out=$(CLAUDE_PLUGIN_ROOT="$root" CLAUDE_PROJECT_DIR="$root" "$@")
  [ "$(printf '%s\n' "$out" | head -1 | tr -d '\r')" = "# ult core rules (always on)" ] || err "$label did not start with the core rules"
  printf '%s' "$out" | grep -q "Quiet runner" || err "$label did not print the quiet runner"
}

guard_cases commit-guard.sh bash "$root/hooks/commit-guard.sh"
runner_cases ult-run 'seq 1 500' 'seq 1 500; exit 3' bash "$root/bin/ult-run"
session_case session-start.sh bash hooks/session-start.sh
CLAUDE_PROJECT_DIR="$root" bash hooks/commit-guard.sh </dev/null 2>/dev/null || err "this repo's own diff trips commit-guard.sh"

if [ -n "$ps" ]; then
  guard_cases commit-guard.ps1 "$ps" -NoProfile -ExecutionPolicy Bypass -File "$root/hooks/commit-guard.ps1"
  runner_cases ult-run.ps1 '1..500' '1..500; exit 3' "$ps" -NoProfile -ExecutionPolicy Bypass -File "$root/bin/ult-run.ps1"
  session_case session-start.ps1 "$ps" -NoProfile -ExecutionPolicy Bypass -File "$root/hooks/session-start.ps1"
  CLAUDE_PROJECT_DIR="$root" "$ps" -NoProfile -ExecutionPolicy Bypass -File "$root/hooks/commit-guard.ps1" </dev/null 2>/dev/null || err "this repo's own diff trips commit-guard.ps1"
fi

hook_commands() {
  "$py" -c 'import json
for event in json.load(open("hooks/hooks.json"))["hooks"].values():
    for matcher in event:
        for hook in matcher["hooks"]:
            print(hook["command"])'
}
plugin_root="$root"
command -v cygpath >/dev/null 2>&1 && plugin_root=$(cygpath -m "$root")
tmp=$(mktemp -d)
n=0
while IFS= read -r cmd; do
  cmd=${cmd%$'\r'}
  cmd=${cmd//'${CLAUDE_PLUGIN_ROOT}'/$plugin_root}
  n=$((n + 1))
  for sh in sh bash; do
    out=$(CLAUDE_PLUGIN_ROOT="$root" CLAUDE_PROJECT_DIR="$root" "$sh" -c "$cmd" </dev/null 2>&1) || err "hook command $n failed under $sh: $out"
    case "$cmd" in
      *session-start*) [ "$(printf '%s\n' "$out" | head -1)" = "# ult core rules (always on)" ] || err "hook command $n under $sh: unexpected first line" ;;
      *) [ -z "$out" ] || err "hook command $n under $sh printed: $out" ;;
    esac
  done
  if [ -n "$ps" ] && command -v powershell.exe >/dev/null 2>&1; then
    printf '%s\n' "$cmd" > "$tmp/hook$n.ps1"
    out=$(CLAUDE_PLUGIN_ROOT="$root" CLAUDE_PROJECT_DIR="$root" "$ps" -NoProfile -ExecutionPolicy Bypass -File "$tmp/hook$n.ps1" </dev/null 2>&1) || err "hook command $n failed under PowerShell: $out"
    case "$cmd" in
      *session-start*) [ "$(printf '%s\n' "$out" | head -1 | tr -d '\r')" = "# ult core rules (always on)" ] || err "hook command $n under PowerShell: unexpected first line: $(printf '%s\n' "$out" | head -1)" ;;
      *) [ -z "$out" ] || err "hook command $n under PowerShell printed: $out" ;;
    esac
  fi
done < <(hook_commands)
rm -rf "$tmp"
[ "$n" -ge 3 ] || err "expected at least 3 hook commands, found $n"

[ "$fail" -eq 0 ] && echo "PASS core=${words}w skills=$(ls skills | wc -l) agents=$(ls agents | wc -l) powershell=${ps:-not-tested}"
exit "$fail"
