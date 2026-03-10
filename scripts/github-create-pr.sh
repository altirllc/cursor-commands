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
#   $5 - Org (optional, overrides git remote parsing)
#   $6 - Repo (optional, overrides git remote parsing)
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

# Use explicit org/repo if provided; otherwise derive from git remote
if [[ -z "${ORG}" || -z "${REPO}" ]]; then
  REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

  if [[ -z "${REMOTE_URL}" ]]; then
    echo "Error: Could not get git remote URL" >&2
    exit 1
  fi

  # Parse org/repo using sed (portable, no BASH_REMATCH)
  ORG_REPO=$(echo "$REMOTE_URL" | sed -n 's|.*github\.com[:/]\([^/][^/]*\)/\([^/.]*\).*|\1 \2|p')
  ORG=$(echo "$ORG_REPO" | cut -d' ' -f1)
  REPO=$(echo "$ORG_REPO" | cut -d' ' -f2)
fi

# Validate org/repo before API call
if [[ -z "${ORG}" || -z "${REPO}" ]]; then
  echo "Error: Could not determine org/repo. Pass as args 5 and 6, or ensure git remote is set." >&2
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
