# Cursor — Setup Guide

How to use the autonomous multi-agent orchestrator with Cursor IDE.

---

## Overview

This architecture uses **Cursor subagents** for true context isolation. Each phase runs in its own context window, which means:

- PR Review and Blocker Resolver have genuinely fresh context (not simulated)
- Subagents can run in parallel when needed
- Long phases don't bloat the main conversation

---

## Prerequisites

### GitHub App Authentication

The orchestrator uses GitHub App tokens for git push and PR creation. **Complete the GitHub App setup first:**

→ **[GitHub App Setup Guide](_shared/github-app-setup.md)**

This is required for the orchestrator to create branches and PRs automatically.

---

## Setup for a New Project

```bash
# Clone this repo
git clone https://github.com/your-org/cursor-commands.git /tmp/cursor-commands

# Create .cursor structure in your project
cd your-project
mkdir -p .cursor/agents .cursor/commands .cursor/rules

# Copy agents folder (includes _shared, workflows, feature, bug-fix, etc.)
cp -r /tmp/cursor-commands/stacks/ui/react/agents/* .cursor/agents/

# Copy orchestrator to commands folder (invoke with /orchestrator)
cp /tmp/cursor-commands/stacks/ui/react/orchestrator/cursor-orchestrator.md .cursor/commands/orchestrator.md

# Copy rules
cp -r /tmp/cursor-commands/stacks/ui/react/rules/* .cursor/rules/

# Copy GitHub scripts (required for git push and PR creation)
cp -r /tmp/cursor-commands/scripts/ scripts/

# Edit project-specific files
# .cursor/rules/react-conventions.md  — fill with YOUR project's conventions
# .cursor/rules/memory.md             — fill as you discover project-specific landmines
```

---

## Project Structure After Setup

This matches the structure you create in your codebase:

```
your-project/
├── .cursor/
│   ├── agents/
│   │   ├── _shared/
│   │   │   ├── autonomous-protocol.md
│   │   │   ├── context-packet.md
│   │   │   ├── handoff-format.md
│   │   │   └── quality-gate.md
│   │   ├── workflows/
│   │   │   ├── feature.md
│   │   │   ├── enhancement.md
│   │   │   └── bug-fix.md
│   │   ├── feature/
│   │   │   ├── subagent-1-feature-clarity.md
│   │   │   ├── subagent-2-feature-plan.md
│   │   │   ├── subagent-3-implement.md
│   │   │   └── subagent-4-test-checklist.md
│   │   ├── bug-fix/
│   │   │   ├── subagent-1-investigate.md
│   │   │   ├── subagent-2-plan.md
│   │   │   ├── subagent-3-implement.md
│   │   │   └── subagent-4-test-checklist.md
│   │   ├── enhancement/
│   │   │   ├── subagent-1-feature-clarity.md
│   │   │   ├── subagent-2-implement.md
│   │   │   └── subagent-3-test-checklist.md
│   │   ├── design-ui/
│   │   │   ├── subagent-ui-scan.md
│   │   │   └── subagent-design-ui.md
│   │   ├── pr-review/
│   │   │   └── subagent-pr-review.md
│   │   ├── pr-description/
│   │   │   └── pr-description.md
│   │   ├── blocker-resolver/
│   │   │   └── blocker-resolver.md
│   │   └── test-executor/
│   │       └── test-executor.md
│   ├── commands/
│   │   └── orchestrator.md           # Invoke with /orchestrator, then paste your task
│   ├── rules/
│   │   ├── react-conventions.md      ← per-project
│   │   └── memory.md                 ← per-project
├── src/
└── ...
```

---

## Running a Task

```
# Open Cursor in your project
# Start a new chat (Cmd+L or Ctrl+L)
# Type /orchestrator and paste your task:

/orchestrator

Task:
- Type: bug-fix
- Description: Clicking Save twice on the settings page creates duplicate entries
- Reproduction: 1. Open /settings 2. Edit name 3. Click Save rapidly
- Clarification answers:
  - "Should we debounce or disable?": "Disable the button after first click"
```

The orchestrator will:

1. Create a worktree with a new branch
2. Delegate to subagents in sequence (`/bug-investigate` → `/bug-plan` → `/bug-implement` → etc.)
3. Run the self-healing review loop (test → review → fix blockers)
4. Create the GitHub PR
5. Clean up the worktree

---

## How Subagent Delegation Works

The orchestrator invokes subagents using `/subagent-name` syntax:

```
/feature-clarity

Context packet:
TASK ID: 20240115-abc
TASK TYPE: feature
...

Task:
Analyze this feature request and produce a clarity handoff.
```

Each subagent:

- Runs in its own context window (isolated)
- Returns a structured handoff block
- The orchestrator parses the handoff and passes it to the next subagent

---

## Available Commands and Subagents

| Name                          | Type     | Description                                                                         |
| ----------------------------- | -------- | ----------------------------------------------------------------------------------- |
| `/orchestrator`               | Command  | Master orchestrator — runs full pipeline. Type `/orchestrator` and paste your task. |
| `/feature-clarity`            | Subagent | Resolves ambiguities for features                                                   |
| `/feature-plan`               | Subagent | Creates implementation plan                                                         |
| `/feature-implement`          | Subagent | Implements code changes                                                             |
| `/feature-test-checklist`     | Subagent | Produces manual test checklist                                                      |
| `/bug-investigate`            | Subagent | Traces root cause of bugs                                                           |
| `/bug-plan`                   | Subagent | Designs minimal fix                                                                 |
| `/bug-implement`              | Subagent | Implements bug fix                                                                  |
| `/bug-test-checklist`         | Subagent | Produces manual test checklist                                                      |
| `/enhancement-clarity`        | Subagent | Resolves ambiguities for small changes                                              |
| `/enhancement-implement`      | Subagent | Implements small changes                                                            |
| `/enhancement-test-checklist` | Subagent | Produces manual test checklist                                                      |
| `/test-executor`              | Subagent | Runs tests, classifies failures                                                     |
| `/pr-review`                  | Subagent | Reviews diff for regressions (fresh context)                                        |
| `/blocker-resolver`           | Subagent | Fixes blockers (fresh context)                                                      |
| `/pr-description`             | Subagent | Generates PR title and body                                                         |
| `/ui-scan`                    | Subagent | One-time UI codebase scan                                                           |
| `/design-ui`                  | Subagent | Designs UI components                                                               |

---

## Running Multiple Tasks in Parallel

Each task runs in its own worktree, so you can run multiple orchestrators simultaneously:

```bash
# Terminal 1
cursor
> /orchestrator
> Task: bug-fix - duplicate save entries

# Terminal 2
cursor
> /orchestrator
> Task: feature - add OAuth2 login

# Each creates its own worktree and runs independently
```

---

## Fresh Context for Review

The key advantage of Cursor subagents is **real context isolation**.

When the orchestrator invokes `/pr-review` or `/blocker-resolver`, it passes ONLY:

- The git diff
- The original task description
- The blocker list (for blocker-resolver)

The subagent never sees:

- Implementation reasoning
- Clarity handoffs
- Plan details

This is genuine fresh-context review, not simulated.

---

## Comparison: Cursor vs Claude Code

| Aspect             | Cursor (subagents)                                               | Claude Code (inline)                   |
| ------------------ | ---------------------------------------------------------------- | -------------------------------------- |
| Context isolation  | Real — each subagent has own context                             | Simulated — same context throughout    |
| Fresh review       | Genuine — subagent never saw prior phases                        | Simulated — agent told to ignore prior |
| Parallel execution | Supported                                                        | Not supported                          |
| File location      | `.cursor/agents/`                                                | `.claude/agents/`                      |
| Orchestrator       | `.cursor/commands/orchestrator.md` — invoke with `/orchestrator` | Reads and executes inline              |

---

## Troubleshooting

**Subagent not found?**

- Ensure the file is in `.cursor/agents/` with valid YAML frontmatter
- Check that `name` in frontmatter matches the `/name` you're invoking

**Orchestrator stops and asks questions?**

- Add clarification answers to your task description
- The orchestrator follows the autonomous protocol — it should make decisions and document them as DECISION_POINT

**PR has UNRESOLVED_BLOCKERS?**

- The review loop exhausted its 5 iterations
- Check the blockers in the PR description
- Fix manually or re-run with more specific clarification answers

**Git operations fail?**

- Ensure GitHub App environment variables are set (see [GitHub App Setup](_shared/github-app-setup.md))
- Run `bash scripts/mint-github-token.sh` to verify token generation works
- Check that the GitHub App is installed for your repository

---

## Updating Agents

When you want to improve an agent:

1. Edit the agent file in the `cursor-commands` repo (source of truth)
2. Copy the updated file to your project's `.cursor/agents/` directory
3. Or set up a script to sync:

```bash
# sync-agents.sh
rsync -av /path/to/cursor-commands/stacks/ui/react/agents/ your-project/.cursor/agents/ \
  --exclude='*.DS_Store'
cp /path/to/cursor-commands/stacks/ui/react/orchestrator/cursor-orchestrator.md your-project/.cursor/commands/orchestrator.md
rsync -av /path/to/cursor-commands/scripts/ your-project/scripts/ \
  --exclude='*.DS_Store'
```

The `rules/` directory is excluded because it contains project-specific configuration.

---

## Shared Files with Claude Code

The agent files work with both Cursor and Claude Code:

- **YAML frontmatter** is ignored by Claude Code, used by Cursor
- **Agent content** is identical for both tools
- **Only the orchestrator differs**: `orchestrator.md` (Claude) vs `cursor-orchestrator.md` (Cursor)

To use the same agents with Claude Code, symlink or copy to `.claude/agents/`.
