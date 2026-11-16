#!/usr/bin/env bash
cat "${CLAUDE_PLUGIN_ROOT}/hooks/core.md"

root="${CLAUDE_PROJECT_DIR:-$PWD}"
echo "Quiet runner: bash \"${CLAUDE_PLUGIN_ROOT}/bin/ult-run\" '<command>'"
if [ -f "$root/docs/map/README.md" ]; then
  echo "Feature map: docs/map/README.md"
else
  echo "No feature map in this repo. Run /ult:setup once to create it and record the check commands."
fi
if [ -f "$root/.ult/task.md" ]; then
  echo "Unfinished task: .ult/task.md. Read it before anything else and continue from the first unticked slice."
fi
exit 0
