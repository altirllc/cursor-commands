#!/bin/bash
#
# Generates a GitHub App installation access token.
#
# Required environment variables:
#   GITHUB_APP_ID            - Your GitHub App's ID
#   GITHUB_APP_INSTALLATION_ID - The installation ID for your org/repo
#   GITHUB_APP_PRIVATE_KEY   - Contents of the .pem file (not a path)
#
# Usage:
#   GITHUB_TOKEN=$(bash scripts/github-get-token.sh)
#
# The returned token is valid for 1 hour.

set -euo pipefail

# Validate required environment variables
if [[ -z "${GITHUB_APP_ID:-}" ]]; then
  echo "Error: GITHUB_APP_ID environment variable is not set" >&2
  exit 1
fi

if [[ -z "${GITHUB_APP_INSTALLATION_ID:-}" ]]; then
  echo "Error: GITHUB_APP_INSTALLATION_ID environment variable is not set" >&2
  exit 1
fi

if [[ -z "${GITHUB_APP_PRIVATE_KEY:-}" ]]; then
  echo "Error: GITHUB_APP_PRIVATE_KEY environment variable is not set" >&2
  exit 1
fi

# Generate JWT (valid for 10 minutes, used only to get the installation token)
NOW=$(date +%s)
EXPIRY=$((NOW + 600))

# Base64 URL-safe encoding (no padding, +/ replaced with -_)
base64url() {
  openssl base64 -e -A | tr '+/' '-_' | tr -d '='
}

HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | base64url)
PAYLOAD=$(echo -n "{\"iat\":${NOW},\"exp\":${EXPIRY},\"iss\":\"${GITHUB_APP_ID}\"}" | base64url)

SIGNATURE=$(echo -n "${HEADER}.${PAYLOAD}" | \
  openssl dgst -sha256 -sign <(echo "${GITHUB_APP_PRIVATE_KEY}") | \
  base64url)

JWT="${HEADER}.${PAYLOAD}.${SIGNATURE}"

# Exchange JWT for installation access token (valid for 1 hour)
RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer ${JWT}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/app/installations/${GITHUB_APP_INSTALLATION_ID}/access_tokens")

# Extract token from response
TOKEN=$(echo "${RESPONSE}" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [[ -z "${TOKEN}" ]]; then
  echo "Error: Failed to get installation token. Response:" >&2
  echo "${RESPONSE}" >&2
  exit 1
fi

echo "${TOKEN}"
