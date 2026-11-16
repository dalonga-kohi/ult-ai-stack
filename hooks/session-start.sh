#!/usr/bin/env bash
cat "${CLAUDE_PLUGIN_ROOT}/hooks/core.md"

root="${CLAUDE_PROJECT_DIR:-$PWD}"
if [ -f "$root/docs/map/README.md" ]; then
  echo "Feature map: docs/map/README.md"
else
  echo "No feature map in this repo. Run /ult:setup once to create it and record the check commands."
fi
exit 0
