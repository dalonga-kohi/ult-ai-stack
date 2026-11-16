#!/usr/bin/env bash
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root" || exit 1
fail=0
err() { echo "FAIL $*"; fail=1; }

for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json hooks/hooks.json; do
  python3 -m json.tool "$f" >/dev/null 2>&1 || err "$f: invalid JSON"
done

for f in hooks/*.sh scripts/*.sh; do
  bash -n "$f" || err "$f: syntax"
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

guard="$root/hooks/commit-guard.sh"
tmp=$(mktemp -d)
(
  cd "$tmp" && git init -q && git config user.email t@t && git config user.name t
  echo "const a = 1;" > a.ts && git add a.ts && git commit -qm init
  export CLAUDE_PROJECT_DIR="$tmp"

  echo "const b = 2;" >> a.ts && git add a.ts
  bash "$guard" 2>/dev/null || { echo "FAIL guard blocked a clean diff"; exit 1; }

  printf '// TO%s: later\n' "DO" >> a.ts && git add a.ts
  bash "$guard" 2>/dev/null; [ $? -eq 2 ] || { echo "FAIL guard passed a deferral marker"; exit 1; }
  git checkout -q HEAD -- a.ts 2>/dev/null; git reset -q --hard

  printf '// @ts-ig%s\n' "nore" >> a.ts
  bash "$guard" 2>/dev/null; [ $? -eq 2 ] || { echo "FAIL guard passed an unstaged suppression"; exit 1; }
  git reset -q --hard

  printf '// @ts-expect-er%s vendor bug, see #12\n' "ror" >> a.ts && git add a.ts
  bash "$guard" 2>/dev/null || { echo "FAIL guard blocked a line that references an issue"; exit 1; }
  git reset -q --hard

  printf 'TO%s list\n' "DO" > notes.md && git add notes.md
  bash "$guard" 2>/dev/null || { echo "FAIL guard scanned markdown"; exit 1; }
) || fail=1
rm -rf "$tmp"

out=$(CLAUDE_PLUGIN_ROOT="$root" CLAUDE_PROJECT_DIR="$root" bash hooks/session-start.sh)
printf '%s' "$out" | grep -q "ult core rules" || err "session-start.sh did not print the core rules"

CLAUDE_PROJECT_DIR="$root" bash "$guard" 2>/dev/null || err "this repo's own diff trips the commit guard"

[ "$fail" -eq 0 ] && echo "PASS core=${words}w skills=$(ls skills | wc -l) agents=$(ls agents | wc -l)"
exit "$fail"
