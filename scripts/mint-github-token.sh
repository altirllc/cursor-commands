#!/bin/bash
#
# Wrapper script that loads .env.github and calls github-get-token.sh
# Use this instead of github-get-token.sh directly when env vars aren't set.
#
# Usage:
#   GITHUB_TOKEN=$(bash scripts/mint-github-token.sh)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load .env.github if it exists and env vars aren't already set
if [[ -z "${GITHUB_APP_ID:-}" ]] && [[ -f "$PROJECT_ROOT/.env.github" ]]; then
  set -a
  source "$PROJECT_ROOT/.env.github"
  set +a
fi

exec "$SCRIPT_DIR/github-get-token.sh"
