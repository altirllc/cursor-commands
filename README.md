# Autonomous Multi-Agent Orchestrator

A production-grade, fully autonomous multi-agent system for software development. Describe a task, answer clarity questions, walk away — receive a PR on GitHub.

---

## Philosophy

**Zero human intervention between task submission and PR creation.**

- AI writes bad code when it guesses — these agents make guessing structurally impossible
- Every claim must be backed by a file the agent actually read (anti-hallucination)
- No code is written before requirements are fully understood
- Existing working code is sacred — zero regression is always priority #1
- Fresh context isolation: review agents never see implementation reasoning
- Self-healing: failed reviews loop back automatically (max 5 iterations)

---

## Getting Started

### 1. Choose Your Tool

| Tool | Guide |
|------|-------|
| **Cursor IDE** | [tools/cursor.md](tools/cursor.md) |
| **Claude Code CLI** | [tools/claude-code.md](tools/claude-code.md) |

### 2. Choose Your Stack

| Stack | Path |
|-------|------|
| **React + TypeScript** | [stacks/ui/react/](stacks/ui/react/) |

Each stack has its own README with architecture details, workflows, and directory structure.

### 3. Set Up GitHub App Authentication

The orchestrator uses GitHub App tokens for git push and PR creation:

→ **[GitHub App Setup Guide](tools/_shared/github-app-setup.md)**

---

## Repository Structure

```
.
├── README.md                    # This file
├── shared/
│   └── principles.md            # Universal principles (all stacks)
├── scripts/
│   ├── mint-github-token.sh     # Mints GitHub App installation token (loads .env.github)
│   ├── github-get-token.sh      # Core token generation (called by mint-github-token.sh)
│   └── github-create-pr.sh      # Creates PR via GitHub API
├── tools/
│   ├── cursor.md                # Cursor IDE setup guide
│   ├── claude-code.md           # Claude Code CLI setup guide
│   └── _shared/
│       └── github-app-setup.md  # GitHub App authentication setup
└── stacks/
    └── ui/
        └── react/               # React + TypeScript stack
            ├── README.md        # Stack-specific docs
            ├── agents/          # Subagent definitions
            ├── orchestrator/    # Orchestrator configs
            └── rules/           # Project conventions (customize)
```

---

## Adding New Stacks

The architecture is stack-agnostic. To add a new stack (e.g., Python/FastAPI):

1. Create `stacks/backend/python/` mirroring the React structure
2. Write stack-specific agents referencing the same `_shared/` protocols
3. Add stack-specific `rules/` files
4. Create a README.md with stack-specific documentation

---

## Portability

Copy the relevant stack folder and scripts into any project. Customize:

- `rules/` — your project's coding standards and conventions
- Context packet fields — project name, conventions path, memory path
