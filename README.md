# Multi-Agent Orchestrator

A production-grade orchestration system for software development. Describe a task, stay in control at key decision points, and get a PR on GitHub — with the agent handling execution while you own the plan and code.

---

## Philosophy

**Human owns vision and strategy. Agent executes.**

- **You decide.** The orchestrator stops after clarity and after planning for your approval. No code is written until you approve the plan.
- **You stay in control.** You can reject plans, provide feedback, and iterate until it fits your vision. The agent does not take full ownership of the codebase.
- **Agent executes.** Once you approve, the orchestrator runs implementation, tests, and review loops. The orchestrator is best at execution—not at full ownership of the codebase.
- **Guarded quality.** Every claim is backed by files the agent actually read (anti-hallucination). Existing working code is sacred—zero regression is priority #1.
- **Structured handoffs.** The orchestrator gives you clear prompts and TASK_IDs so you can re-invoke easily—orchestration without writing long prompts from scratch.
- **Confidence in production.** You retain ownership of the plan and code. The orchestrator excels at execution, not at fully owning the codebase. Changes going to production reflect your strategy and approval.

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
│   ├── setup-github-remote.sh       # Phase 1: parse, mint token, set remote, write .github-setup.env
│   ├── ensure-orchestrator-gitignore.sh  # Ensures .orchestrator-state/ in .gitignore (orchestrator runs at start)
│   ├── mint-github-token.sh         # Mints GitHub App installation token (loads .env.github)
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
