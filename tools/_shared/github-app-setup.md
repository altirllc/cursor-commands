# GitHub App Setup

This guide explains how to configure GitHub App authentication for the autonomous orchestrator. GitHub Apps provide secure, scoped access without requiring personal access tokens or per-user licensing.

---

## Prerequisites

Before starting, verify with your repository owner:

1. **Has a GitHub App been created for your organization?**
2. **Is the App installed for the repository you're working with?**

If not, ask your repo owner to create and install the GitHub App first.

---

## What You Need from Your Repo Owner

Request these three items:

| Item | Description |
|------|-------------|
| **App ID** | Numeric ID from the GitHub App settings page |
| **Installation ID** | Found in the URL at `https://github.com/organizations/{ORG}/settings/installations` → click the app |
| **Private Key (.pem file)** | Downloaded from the App settings (Generate a private key) |

---

## Setup Steps

### 1. Store the Private Key

The `.pem` file from your repo owner will have a name like `your-app-name.YYYY-MM-DD.private-key.pem`.

Save it to a secure location outside any git repository:

```bash
mkdir -p ~/.config/github-app

# Replace the filename with your actual .pem file
# Check what's in Downloads: ls ~/Downloads/*.pem
mv ~/Downloads/your-app-name.YYYY-MM-DD.private-key.pem ~/.config/github-app/

chmod 600 ~/.config/github-app/*.pem
```

**Verify the file was moved:**

```bash
ls -la ~/.config/github-app/
```

You should see your `.pem` file with `-rw-------` permissions.

**Security**: Never commit this file to any repository.

### 2. Configure Environment Variables

Add to your `~/.zshrc` (or `~/.bashrc`):

```bash
export GITHUB_APP_ID="123456"
export GITHUB_APP_INSTALLATION_ID="78901234"
# Use the actual filename of your .pem file
export GITHUB_APP_PRIVATE_KEY="$(cat ~/.config/github-app/your-app-name.YYYY-MM-DD.private-key.pem)"
```

Replace:
- `123456` with your actual App ID
- `78901234` with your actual Installation ID
- `your-app-name.YYYY-MM-DD.private-key.pem` with your actual `.pem` filename

Then reload your shell:

```bash
source ~/.zshrc
```

**Verify environment variables are set:**

```bash
echo "APP_ID: $GITHUB_APP_ID"
echo "INSTALLATION_ID: $GITHUB_APP_INSTALLATION_ID"
echo "PRIVATE_KEY set: $([ -n "$GITHUB_APP_PRIVATE_KEY" ] && echo 'YES' || echo 'NO')"
```

You should see your App ID, Installation ID, and `PRIVATE_KEY set: YES`.

### 3. Copy Scripts to Your Project

When setting up a new project, copy the GitHub scripts:

```bash
cp -r /path/to/cursor-commands/scripts/ your-project/scripts/
```

Or if you've cloned cursor-commands to a temp location:

```bash
cp -r /tmp/cursor-commands/scripts/ your-project/scripts/
```

### 4. Verify Setup

Test that token generation works:

```bash
cd your-project
bash scripts/github-get-token.sh
```

If successful, it outputs a token (starts with `ghs_`). If it fails, check:
- Environment variables are set correctly
- The `.pem` file path is correct
- The App is installed for your repository

---

## How It Works

```
Your credentials (App ID + Private Key)
    ↓
github-get-token.sh creates a JWT (10 min lifetime)
    ↓
JWT is exchanged with GitHub for an Installation Token (1 hour lifetime)
    ↓
Token is used for git push and PR creation
```

The orchestrator:
1. Mints a token at the start of each task
2. Configures git remote to use the token
3. Uses the token for push and PR creation
4. Restores the original remote URL when done

---

## Required GitHub App Permissions

Ensure your GitHub App has at least these permissions:

| Permission | Access Level | Purpose |
|------------|--------------|---------|
| Contents | Read & Write | Push commits to branches |
| Pull requests | Read & Write | Create PRs |
| Metadata | Read | Access repository info |

---

## Troubleshooting

**"GITHUB_APP_ID environment variable is not set"**
- Run `echo $GITHUB_APP_ID` to check if it's set
- Ensure you ran `source ~/.zshrc` after editing

**"Failed to get installation token"**
- Verify the App ID and Installation ID are correct
- Check that the App is installed for your specific repository
- Ensure the private key hasn't expired (regenerate if needed)

**"Could not parse org/repo from remote URL"**
- The script expects standard GitHub URLs
- Run `git remote get-url origin` to see your remote format
- Supported formats: `https://github.com/org/repo` or `git@github.com:org/repo`

**Token works for git but PR creation fails**
- Verify the App has "Pull requests: Read & Write" permission
- Check that the base branch exists (default is `develop`)

---

## Security Notes

1. **Never commit credentials** — The `.pem` file and environment variables should never be in any repository
2. **Token scope** — Installation tokens are scoped to the repositories where the App is installed
3. **Token lifetime** — Tokens expire after 1 hour; the orchestrator mints fresh tokens per task
4. **Audit trail** — All actions appear as the GitHub App in commit/PR history, not as a personal user
