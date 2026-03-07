# Cursor — Setup Guide

How to use the autonomous multi-agent orchestrator with Cursor IDE.

---

## Overview

This architecture uses **Cursor subagents** for true context isolation. Each phase runs in its own context window, which means:

- PR Review and Blocker Resolver have genuinely fresh context (not simulated)
- Subagents can run in parallel when needed
- Long phases don't bloat the main conversation

---

## Setup for a New Project

```bash
# Clone this repo
git clone https://github.com/your-org/cursor-commands.git /tmp/cursor-commands

# Copy the agent architecture into your project
cp -r /tmp/cursor-commands/stacks/ui/react/_shared/ your-project/.cursor/agents/_shared/
cp -r /tmp/cursor-commands/stacks/ui/react/agents/ your-project/.cursor/agents/
cp -r /tmp/cursor-commands/stacks/ui/react/workflows/ your-project/.cursor/agents/workflows/
cp -r /tmp/cursor-commands/stacks/ui/react/orchestrator/cursor-orchestrator.md your-project/.cursor/agents/orchestrator.md
cp -r /tmp/cursor-commands/stacks/ui/react/rules/ your-project/.cursor/rules/

# Edit project-specific files
# your-project/.cursor/rules/react-conventions.md  — fill with YOUR project's conventions
# your-project/.cursor/rules/memory.md             — fill as you discover project-specific landmines
```

---

## Project Structure After Setup

```
your-project/
├── .cursor/
│   ├── agents/                        # Cursor subagent directory
│   │   ├── _shared/
│   │   │   ├── autonomous-protocol.md
│   │   │   ├── context-packet.md
│   │   │   ├── handoff-format.md
│   │   │   └── quality-gate.md
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
│   │   ├── test-executor/
│   │   │   └── test-executor.md
│   │   ├── workflows/
│   │   │   ├── feature.md
│   │   │   ├── enhancement.md
│   │   │   └── bug-fix.md
│   │   └── orchestrator.md            # Master orchestrator (delegates to subagents)
│   └── rules/
│       ├── react-conventions.md       ← per-project
│       └── memory.md                  ← per-project
├── src/
└── ...
```

---

## Running a Task

```
# Open Cursor in your project
# Start a new chat (Cmd+L or Ctrl+L)
# Invoke the orchestrator:

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

## Available Subagents

| Subagent | Description |
|----------|-------------|
| `/orchestrator` | Master orchestrator — delegates to other subagents |
| `/feature-clarity` | Resolves ambiguities for features |
| `/feature-plan` | Creates implementation plan |
| `/feature-implement` | Implements code changes |
| `/feature-test-checklist` | Produces manual test checklist |
| `/bug-investigate` | Traces root cause of bugs |
| `/bug-plan` | Designs minimal fix |
| `/bug-implement` | Implements bug fix |
| `/bug-test-checklist` | Produces manual test checklist |
| `/enhancement-clarity` | Resolves ambiguities for small changes |
| `/enhancement-implement` | Implements small changes |
| `/enhancement-test-checklist` | Produces manual test checklist |
| `/test-executor` | Runs tests, classifies failures |
| `/pr-review` | Reviews diff for regressions (fresh context) |
| `/blocker-resolver` | Fixes blockers (fresh context) |
| `/pr-description` | Generates PR title and body |
| `/ui-scan` | One-time UI codebase scan |
| `/design-ui` | Designs UI components |

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

| Aspect | Cursor (subagents) | Claude Code (inline) |
|--------|-------------------|---------------------|
| Context isolation | Real — each subagent has own context | Simulated — same context throughout |
| Fresh review | Genuine — subagent never saw prior phases | Simulated — agent told to ignore prior |
| Parallel execution | Supported | Not supported |
| File location | `.cursor/agents/` | `.claude/agents/` |
| Orchestrator | Delegates via `/subagent-name` | Reads and executes inline |

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
- Ensure `gh` CLI is installed and authenticated (`gh auth login`)
- Check that you have push access to the repository

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
rsync -av /path/to/cursor-commands/stacks/ui/react/_shared/ your-project/.cursor/agents/_shared/
rsync -av /path/to/cursor-commands/stacks/ui/react/orchestrator/cursor-orchestrator.md your-project/.cursor/agents/orchestrator.md
```

The `rules/` directory is excluded because it contains project-specific configuration.

---

## Shared Files with Claude Code

The agent files work with both Cursor and Claude Code:

- **YAML frontmatter** is ignored by Claude Code, used by Cursor
- **Agent content** is identical for both tools
- **Only the orchestrator differs**: `orchestrator.md` (Claude) vs `cursor-orchestrator.md` (Cursor)

To use the same agents with Claude Code, symlink or copy to `.claude/agents/`.
