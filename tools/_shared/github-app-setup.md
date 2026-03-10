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

| Item                        | Description                                                                                         |
| --------------------------- | --------------------------------------------------------------------------------------------------- |
| **App ID**                  | Numeric ID from the GitHub App settings page                                                        |
| **Installation ID**         | Found in the URL at `https://github.com/organizations/{ORG}/settings/installations` → click the app |
| **Private Key (.pem file)** | Downloaded from the App settings (Generate a private key)                                           |

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

### 2. Create the Environment File

Create a `.env.github` file in your project root. This file is gitignored and stores your credentials locally.

**Option A: Copy from the example template**

```bash
cp .env.github.example .env.github
```

Then edit `.env.github` with your actual values.

**Option B: Create directly**

Create `.env.github` in your project root with these contents:

```bash
GITHUB_APP_ID=123456
GITHUB_APP_INSTALLATION_ID=78901234
GITHUB_APP_PRIVATE_KEY="$(cat ~/.config/github-app/your-app-name.YYYY-MM-DD.private-key.pem)"
```

**Important**: The private key must be the actual key content, not a file path. To get the content:

```bash
cat ~/.config/github-app/your-app-name.YYYY-MM-DD.private-key.pem
```

Then paste the full key (including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----` lines) into `.env.github`:

```bash
GITHUB_APP_ID=123456
GITHUB_APP_INSTALLATION_ID=78901234
GITHUB_APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
...your key content...
-----END RSA PRIVATE KEY-----"
```

**Replace these values:**

- `123456` → your actual App ID
- `78901234` → your actual Installation ID
- The private key content → your actual `.pem` file contents

### 3. Verify the Environment File

Check that `.env.github` exists and is gitignored:

```bash
# Should show your file
ls -la .env.github

# Should show .env.github is ignored
git status --ignored | grep .env.github
```

### 4. Copy Scripts to Your Project

When setting up a new project, copy the GitHub scripts:

```bash
cp -r /path/to/cursor-commands/scripts/ your-project/scripts/
```

Or if you've cloned cursor-commands to a temp location:

```bash
cp -r /tmp/cursor-commands/scripts/ your-project/scripts/
```

### 5. Verify Setup

Test that token generation works:

```bash
cd your-project
bash scripts/mint-github-token.sh
```

If successful, it outputs a token (starts with `ghs_`). If it fails, check:

- `.env.github` file exists in project root
- The App ID and Installation ID are correct
- The private key content is correct (not a file path)
- The App is installed for your repository

---

## How It Works

```
.env.github (App ID + Private Key)
    ↓
mint-github-token.sh loads .env.github
    ↓
github-get-token.sh creates a JWT (10 min lifetime)
    ↓
JWT is exchanged with GitHub for an Installation Token (1 hour lifetime)
    ↓
Token is used for git push and PR creation
```

The orchestrator:

1. Calls `mint-github-token.sh` which loads `.env.github`
2. Mints a token at the start of each task
3. Configures git remote to use the token
4. Uses the token for push and PR creation
5. Restores the original remote URL when done

**Why this approach?**

- Works in Cursor's sandbox (which doesn't load `~/.zshrc`)
- Works in CI/CD pipelines
- Portable across machines
- Secrets stay local and gitignored

---

## Required GitHub App Permissions

Ensure your GitHub App has at least these permissions:

| Permission    | Access Level | Purpose                  |
| ------------- | ------------ | ------------------------ |
| Contents      | Read & Write | Push commits to branches |
| Pull requests | Read & Write | Create PRs               |
| Metadata      | Read         | Access repository info   |

---

## Troubleshooting

**"GITHUB_APP_ID environment variable is not set"**

- Ensure `.env.github` exists in your project root
- Check the file has the correct format (no `export` keyword needed)
- Verify you're using `mint-github-token.sh` (not `github-get-token.sh` directly)

**"Failed to get installation token"**

- Verify the App ID and Installation ID are correct
- Check that the App is installed for your specific repository
- Ensure the private key is the actual content, not a file path
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

1. **Never commit credentials** — `.env.github` is gitignored; never add it to version control
2. **Token scope** — Installation tokens are scoped to the repositories where the App is installed
3. **Token lifetime** — Tokens expire after 1 hour; the orchestrator mints fresh tokens per task
4. **Audit trail** — All actions appear as the GitHub App in commit/PR history, not as a personal user
