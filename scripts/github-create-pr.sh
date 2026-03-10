#!/bin/bash
#
# Creates a GitHub Pull Request via the REST API.
#
# This script uses a GitHub App installation token (not gh CLI) for reliability.
#
# Required:
#   GITHUB_TOKEN - Installation access token (from mint-github-token.sh)
#
# Arguments:
#   $1 - Branch name (head branch)
#   $2 - PR title
#   $3 - PR body
#   $4 - Base branch (optional, defaults to "develop")
#
# Usage:
#   GITHUB_TOKEN=$(bash scripts/mint-github-token.sh)
#   PR_URL=$(bash scripts/github-create-pr.sh "feature/my-branch" "PR Title" "PR body text")
#
# The script derives org/repo from the git remote URL.

set -euo pipefail

BRANCH_NAME="${1:-}"
PR_TITLE="${2:-}"
PR_BODY="${3:-}"
BASE_BRANCH="${4:-develop}"

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

# Derive org/repo from git remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

if [[ -z "${REMOTE_URL}" ]]; then
  echo "Error: Could not get git remote URL" >&2
  exit 1
fi

# Parse org/repo from various URL formats:
#   https://github.com/org/repo.git
#   https://github.com/org/repo
#   git@github.com:org/repo.git
#   git@github.com:org/repo
if [[ "${REMOTE_URL}" =~ github\.com[:/]([^/]+)/([^/.]+)(\.git)?$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
else
  echo "Error: Could not parse org/repo from remote URL: ${REMOTE_URL}" >&2
  exit 1
fi

# Escape JSON special characters in PR body
PR_BODY_ESCAPED=$(echo "${PR_BODY}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read())[1:-1])')

# Create PR via GitHub API
RESPONSE=$(curl -s -X POST \
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

# Extract PR URL from response
PR_URL=$(echo "${RESPONSE}" | grep -o '"html_url":"[^"]*pull[^"]*"' | head -1 | cut -d'"' -f4)

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
