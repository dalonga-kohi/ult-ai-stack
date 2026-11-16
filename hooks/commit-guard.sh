#!/usr/bin/env bash
# The marker words are split so this file passes its own check.
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

if cat 2>/dev/null | grep -q -- '--no-verify'; then
  echo "ult commit guard: --no-verify skips the repo's own hooks. Fix what the hook reports and commit without it." >&2
  exit 2
fi

diff=$(git diff --cached -U0 --no-color -- . ':(exclude)*.md' 2>/dev/null)
[ -z "$diff" ] && diff=$(git diff HEAD -U0 --no-color -- . ':(exclude)*.md' 2>/dev/null)
[ -z "$diff" ] && exit 0

markers='(^|[^A-Za-z])(TO''DO|FIX''ME|HA''CK|X''XX)([^A-Za-z]|$)'
suppressions='@ts-ig''nore|@ts-expect-er''ror|@ts-noch''eck|eslint-dis''able|#\[al''low\(|//[[:space:]]*nol''int|type:[[:space:]]*ig''nore|#[[:space:]]*no''qa'

hits=$(printf '%s\n' "$diff" | awk -v pat="$markers|$suppressions" '
  /^\+\+\+ / { file = substr($0, 7); next }
  /^\+/ {
    line = substr($0, 2)
    if (line ~ pat && line !~ /#[0-9]+|issues\/[0-9]+/) print file ": " line
  }')

[ -z "$hits" ] && exit 0

{
  echo "ult commit guard: this commit adds deferral markers or suppressions:"
  printf '%s\n' "$hits" | head -20
  echo "Fix the cause, or open an issue (gh issue create) and reference its number on that line. Then commit again."
} >&2
exit 2
