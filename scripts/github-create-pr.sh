#!/bin/bash
#
# Creates a GitHub Pull Request via the REST API.
#
# This script uses a GitHub App installation token (not gh CLI) for reliability.
#
# URL extraction: Uses jq when available, else grep. The grep fallback can fail
# if GitHub API response format changes; jq is more robust.
#
# Required:
#   GITHUB_TOKEN - Installation access token (from mint-github-token.sh)
#
# Arguments:
#   $1 - Branch name (head branch)
#   $2 - PR title
#   $3 - PR body
#   $4 - Base branch (optional, defaults to "develop")
#   $5 - Org (optional, from .env.github GITHUB_REPO_URL if not passed)
#   $6 - Repo (optional, from .env.github GITHUB_REPO_URL if not passed)
#
# Org/repo: Pass as args 5 and 6, or set GITHUB_REPO_URL in .env.github. No git remote parsing.
#
# Usage:
#   GITHUB_TOKEN=$(bash scripts/mint-github-token.sh)
#   PR_URL=$(bash scripts/github-create-pr.sh "feature/my-branch" "PR Title" "PR body text")
#   # With explicit org/repo (e.g. from setup-github-remote.sh):
#   PR_URL=$(bash scripts/github-create-pr.sh "branch" "Title" "Body" "develop" "myorg" "myrepo")

set -euo pipefail

BRANCH_NAME="${1:-}"
PR_TITLE="${2:-}"
PR_BODY="${3:-}"
BASE_BRANCH="${4:-develop}"
ORG="${5:-}"
REPO="${6:-}"

# Validate arguments
if [[ -z "${BRANCH_NAME}" ]]; then
  echo "Error: Branch name is required (argument 1)" >&2
  exit 1
fi

if [[ -z "${PR_TITLE}" ]]; then
  echo "Error: PR title is required (argument 2)" >&2
  exit 1
fi

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Error: GITHUB_TOKEN environment variable is not set" >&2
  echo "Run: GITHUB_TOKEN=\$(bash scripts/mint-github-token.sh)" >&2
  exit 1
fi

# Use explicit org/repo if provided; otherwise load from .env.github GITHUB_REPO_URL
if [[ -z "${ORG}" || -z "${REPO}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  # If in a worktree, .env.github is in the main repo root
  if [[ -f "$PROJECT_ROOT/.git" ]]; then
    GIT_DIR=$(cd "$PROJECT_ROOT" && sed 's/gitdir: //' .git | tr -d ' \n')
    PROJECT_ROOT=$(dirname "$(dirname "$GIT_DIR")")
  fi
  if [[ ! -f "$PROJECT_ROOT/.env.github" ]]; then
    echo "Error: .env.github not found. Pass org/repo as args 5 and 6, or set GITHUB_REPO_URL in .env.github." >&2
    exit 1
  fi
  set -a
  # shellcheck source=/dev/null
  source "$PROJECT_ROOT/.env.github"
  set +a
  if [[ -z "${GITHUB_REPO_URL:-}" ]]; then
    echo "Error: GITHUB_REPO_URL is required in .env.github when org/repo not passed as args." >&2
    exit 1
  fi
  ORG_REPO=$(echo "$GITHUB_REPO_URL" | sed -n 's|.*github\.com[:/]\([^/][^/]*\)/\([^/.]*\).*|\1 \2|p')
  ORG=$(echo "$ORG_REPO" | cut -d' ' -f1)
  REPO=$(echo "$ORG_REPO" | cut -d' ' -f2)
fi

# Validate org/repo before API call
if [[ -z "${ORG}" || -z "${REPO}" ]]; then
  echo "Error: Could not determine org/repo. Pass as args 5 and 6, or set GITHUB_REPO_URL in .env.github." >&2
  exit 1
fi

# Escape JSON special characters in PR body
PR_BODY_ESCAPED=$(echo "${PR_BODY}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read())[1:-1])')

# Create PR via GitHub API (-L follows redirects for renamed repos)
RESPONSE=$(curl -s -L -X POST \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${ORG}/${REPO}/pulls" \
  -d "{
    \"title\": \"${PR_TITLE}\",
    \"body\": \"${PR_BODY_ESCAPED}\",
    \"head\": \"${BRANCH_NAME}\",
    \"base\": \"${BASE_BRANCH}\"
  }")

# Extract PR URL from response (jq preferred; grep fallback if jq unavailable)
# Note: grep-based extraction can fail if GitHub API response format changes.
if command -v jq >/dev/null 2>&1; then
  PR_URL=$(echo "${RESPONSE}" | jq -r '.html_url // empty')
else
  PR_URL=$(echo "${RESPONSE}" | grep -o '"html_url":"[^"]*pull[^"]*"' | head -1 | cut -d'"' -f4)
fi

if [[ -z "${PR_URL}" ]]; then
  # Check for error message
  ERROR_MSG=$(echo "${RESPONSE}" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)
  if [[ -n "${ERROR_MSG}" ]]; then
    echo "Error: GitHub API returned: ${ERROR_MSG}" >&2
  else
    echo "Error: Failed to create PR. Response:" >&2
    echo "${RESPONSE}" >&2
  fi
  exit 1
fi

echo "${PR_URL}"
