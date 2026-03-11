#!/bin/bash
#
# Sets up GitHub remote for push operations using a GitHub App token.
# Runs in a single process to avoid shell-state issues (BASH_REMATCH, etc.).
#
# Writes ORIGINAL_REMOTE, ORG, REPO, GITHUB_TOKEN to WORKTREE_PATH/.github-setup.env
# for use by the orchestrator in Phase 4 (PR creation).
#
# Usage:
#   bash scripts/setup-github-remote.sh "$WORKTREE_PATH"
#
# Required: .env.github with GITHUB_APP_ID, GITHUB_APP_INSTALLATION_ID, GITHUB_APP_PRIVATE_KEY, GITHUB_REPO_URL

set -euo pipefail

WORKTREE_PATH="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Resolve worktree path relative to script's project root if needed
if [[ "$WORKTREE_PATH" != /* ]]; then
  WORKTREE_PATH="$SCRIPT_PROJECT_ROOT/$WORKTREE_PATH"
fi

if [[ ! -d "$WORKTREE_PATH" ]]; then
  echo "Error: Worktree path does not exist: $WORKTREE_PATH" >&2
  exit 1
fi

# Find main repo root for .env.github (worktrees have .git as file, main repo has .git as dir)
if [[ -f "$WORKTREE_PATH/.git" ]]; then
  GIT_DIR=$(cd "$WORKTREE_PATH" && sed 's/gitdir: //' .git | tr -d ' \n')
  PROJECT_ROOT=$(dirname "$(dirname "$GIT_DIR")")
else
  PROJECT_ROOT="$WORKTREE_PATH"
fi

# Get original remote URL
ORIGINAL_REMOTE=$(cd "$WORKTREE_PATH" && git remote get-url origin 2>/dev/null || echo "")

if [[ -z "$ORIGINAL_REMOTE" ]]; then
  echo "Error: Could not get git remote URL from $WORKTREE_PATH" >&2
  exit 1
fi

# Load .env.github and require GITHUB_REPO_URL (no fallback to git remote parsing)
if [[ ! -f "$PROJECT_ROOT/.env.github" ]]; then
  echo "Error: .env.github not found at $PROJECT_ROOT/.env.github" >&2
  exit 1
fi
set -a
# shellcheck source=/dev/null
source "$PROJECT_ROOT/.env.github"
set +a

if [[ -z "${GITHUB_REPO_URL:-}" ]]; then
  echo "Error: GITHUB_REPO_URL is required in .env.github (e.g. https://github.com/org/repo.git)" >&2
  exit 1
fi

ORG_REPO=$(echo "$GITHUB_REPO_URL" | sed -n 's|.*github\.com[:/]\([^/][^/]*\)/\([^/.]*\).*|\1 \2|p')
ORG=$(echo "$ORG_REPO" | cut -d' ' -f1)
REPO=$(echo "$ORG_REPO" | cut -d' ' -f2)

if [[ -z "$ORG" || -z "$REPO" ]]; then
  echo "Error: Could not parse org/repo from GITHUB_REPO_URL: $GITHUB_REPO_URL" >&2
  exit 1
fi

# Mint token (runs from project root for .env.github)
GITHUB_TOKEN=$(cd "$PROJECT_ROOT" && bash "$SCRIPT_DIR/mint-github-token.sh")

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Error: Failed to mint GitHub token" >&2
  exit 1
fi

# Set remote to use token for push operations
(cd "$WORKTREE_PATH" && git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${ORG}/${REPO}.git")

# Write env file for Phase 4 (PR creation)
ENV_FILE="$WORKTREE_PATH/.github-setup.env"
{
  printf 'export ORIGINAL_REMOTE=%q\n' "$ORIGINAL_REMOTE"
  printf 'export ORG=%q\n' "$ORG"
  printf 'export REPO=%q\n' "$REPO"
  printf 'export GITHUB_TOKEN=%q\n' "$GITHUB_TOKEN"
} > "$ENV_FILE"
