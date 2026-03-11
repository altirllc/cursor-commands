#!/bin/bash
#
# Updates an existing GitHub Pull Request's title and/or body via the REST API.
#
# Required:
#   GITHUB_TOKEN - Installation access token (from mint-github-token.sh)
#
# Arguments:
#   $1 - PR number (e.g., 134)
#   $2 - PR title (optional; omit to keep existing)
#   $3 - PR body (optional; omit to keep existing)
#   $4 - Org (optional, from .env.github GITHUB_REPO_URL if not passed)
#   $5 - Repo (optional, from .env.github GITHUB_REPO_URL if not passed)
#
# Usage:
#   GITHUB_TOKEN=$(bash scripts/mint-github-token.sh)
#   bash scripts/github-update-pr.sh 134 "New Title" "New body"
#

set -euo pipefail

PR_NUMBER="${1:-}"
PR_TITLE="${2:-}"
PR_BODY="${3:-}"
ORG="${4:-}"
REPO="${5:-}"

if [[ -z "${PR_NUMBER}" ]]; then
  echo "Error: PR number is required (argument 1)" >&2
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
  if [[ -f "$PROJECT_ROOT/.git" ]]; then
    GIT_DIR=$(cd "$PROJECT_ROOT" && sed 's/gitdir: //' .git | tr -d ' \n')
    PROJECT_ROOT=$(dirname "$(dirname "$GIT_DIR")")
  fi
  if [[ ! -f "$PROJECT_ROOT/.env.github" ]]; then
    echo "Error: .env.github not found. Pass org/repo as args 4 and 5, or set GITHUB_REPO_URL in .env.github." >&2
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

# Build JSON payload (same escaping as github-create-pr.sh)
if [[ -z "${PR_TITLE}" && -z "${PR_BODY}" ]]; then
  echo "Error: Provide at least PR title or body to update" >&2
  exit 1
fi

PAYLOAD_FILE=$(mktemp)
trap 'rm -f "${PAYLOAD_FILE}"' EXIT

# Build JSON: {"title": "...", "body": "..."} with proper escaping
if [[ -n "${PR_TITLE}" && -n "${PR_BODY}" ]]; then
  TITLE_ESC=$(printf '%s' "${PR_TITLE}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  BODY_ESC=$(printf '%s' "${PR_BODY}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  printf '{"title":%s,"body":%s}' "${TITLE_ESC}" "${BODY_ESC}" > "${PAYLOAD_FILE}"
elif [[ -n "${PR_TITLE}" ]]; then
  TITLE_ESC=$(printf '%s' "${PR_TITLE}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  printf '{"title":%s}' "${TITLE_ESC}" > "${PAYLOAD_FILE}"
else
  BODY_ESC=$(printf '%s' "${PR_BODY}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  printf '{"body":%s}' "${BODY_ESC}" > "${PAYLOAD_FILE}"
fi

RESPONSE=$(curl -s -L -X PATCH \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/json" \
  "https://api.github.com/repos/${ORG}/${REPO}/pulls/${PR_NUMBER}" \
  -d @"${PAYLOAD_FILE}")

if command -v jq >/dev/null 2>&1; then
  PR_URL=$(echo "${RESPONSE}" | jq -r '.html_url // empty')
  ERROR_MSG=$(echo "${RESPONSE}" | jq -r '.message // empty')
else
  PR_URL=$(echo "${RESPONSE}" | grep -o '"html_url":"[^"]*pull[^"]*"' | head -1 | cut -d'"' -f4)
  ERROR_MSG=$(echo "${RESPONSE}" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)
fi

if [[ -n "${ERROR_MSG}" ]]; then
  echo "Error: GitHub API returned: ${ERROR_MSG}" >&2
  exit 1
fi

if [[ -z "${PR_URL}" ]]; then
  echo "Error: Failed to update PR. Response:" >&2
  echo "${RESPONSE}" >&2
  exit 1
fi

echo "Updated: ${PR_URL}"
