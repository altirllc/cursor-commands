#!/bin/bash
#
# Ensures .orchestrator-state/ is in .gitignore. Idempotent — safe to run multiple times.
# Run from project root.
#
# Usage:
#   bash scripts/ensure-orchestrator-gitignore.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GITIGNORE="$PROJECT_ROOT/.gitignore"
ENTRY=".orchestrator-state/"

cd "$PROJECT_ROOT"

# Create .gitignore if missing
if [[ ! -f "$GITIGNORE" ]]; then
  echo "# Orchestrator state (do not commit)" >> "$GITIGNORE"
  echo "$ENTRY" >> "$GITIGNORE"
  exit 0
fi

# Check if already present
if grep -qE "^$ENTRY$|^\.orchestrator-state/$" "$GITIGNORE" 2>/dev/null; then
  exit 0
fi

# Append if not present
echo "" >> "$GITIGNORE"
echo "# Orchestrator state (do not commit)" >> "$GITIGNORE"
echo "$ENTRY" >> "$GITIGNORE"
