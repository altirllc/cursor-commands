# Claude Code — Tool Configuration

How to use this multi-agent architecture with Claude Code CLI.

---

## Setup for a New Project

```bash
# Clone this repo
git clone https://github.com/your-org/cursor-commands.git /tmp/cursor-commands

# Copy the agent architecture into your project
cp -r /tmp/cursor-commands/stacks/ui/react/_shared/ your-project/.claude/_shared/
cp -r /tmp/cursor-commands/stacks/ui/react/agents/ your-project/.claude/agents/
cp -r /tmp/cursor-commands/stacks/ui/react/workflows/ your-project/.claude/workflows/
cp -r /tmp/cursor-commands/stacks/ui/react/orchestrator/ your-project/.claude/orchestrator/
cp -r /tmp/cursor-commands/stacks/ui/react/rules/ your-project/.claude/rules/

# Edit project-specific files
# your-project/.claude/rules/react-conventions.md  — fill with YOUR project's conventions
# your-project/.claude/rules/memory.md             — fill as you discover project-specific landmines
```

---

## Project Structure After Setup

```
your-project/
├── .claude/
│   ├── _shared/
│   │   ├── autonomous-protocol.md
│   │   ├── context-packet.md
│   │   ├── handoff-format.md
│   │   └── quality-gate.md
│   ├── agents/
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
│   ├── workflows/
│   │   ├── feature.md
│   │   ├── enhancement.md
│   │   └── bug-fix.md
│   ├── orchestrator/
│   │   └── orchestrator.md
│   └── rules/
│       ├── react-conventions.md    ← per-project
│       └── memory.md              ← per-project
├── CLAUDE.md                       ← project-level config
├── src/
└── ...
```

---

## Running a Single Task

```bash
# Open Claude Code in your project
cd your-project
claude

# Provide the task
# Claude reads the orchestrator agent and runs the pipeline autonomously
```

Example prompt:
```
Run the orchestrator for this task:
- Type: bug-fix
- Description: Clicking Save twice on the settings page creates duplicate entries
- Reproduction: 1. Open /settings 2. Edit name 3. Click Save rapidly
- Clarification answers:
  - "Should we debounce or disable?": "Disable the button after first click"
```

---

## Running Multiple Tasks in Parallel

```bash
# Use Claude Code worktree isolation for parallel execution
# Each task runs in its own worktree with its own branch

# Task 1
claude --worktree "Run orchestrator: bug-fix - duplicate save entries"

# Task 2
claude --worktree "Run orchestrator: feature - add OAuth2 login"

# Task 3
claude --worktree "Run orchestrator: enhancement - add loading spinner to dashboard"
```

---

## CLAUDE.md Template for Your Project

Create this at your project root:

```markdown
# Project Configuration

## Agent Behavior
- NEVER ask the human for input during autonomous runs
- When encountering ambiguity, make the safer engineering choice and document it
- Always read existing code before modifying — zero hallucination tolerance
- Follow .claude/rules/react-conventions.md for all code decisions

## Git
- Branch naming: `agent/{task-type}-{task-id}-{short-description}`
- Commit messages: `feat|fix|refactor|test: description` (conventional commits)
- One logical commit per implementation phase

## Testing
- Run `npm test` after every implementation
- If tests fail, read the failure output and fix — do not skip
- Write tests for new functionality (co-locate with component)

## Code Quality
- TypeScript strict mode — no `any` types
- All components must handle loading, error, empty states
- Use existing patterns from codebase — do not invent new ones
- Read .claude/rules/memory.md before starting any task
```

---

## Updating Agents

When you want to improve an agent:

1. Edit the agent file in the `cursor-commands` repo (source of truth)
2. Copy the updated file to your project's `.claude/agents/` directory
3. Or set up a script to sync:

```bash
# sync-agents.sh
rsync -av /path/to/cursor-commands/stacks/ui/react/ your-project/.claude/ \
  --exclude='rules/' \
  --exclude='*.DS_Store'
```

The `rules/` directory is excluded because it contains project-specific configuration.

---

## Adding a New Stack

To add support for Python, Java, or any other stack:

1. Create `stacks/{category}/{stack}/` in the cursor-commands repo
2. Copy the structure: `_shared/`, `agents/`, `workflows/`, `orchestrator/`, `rules/`
3. Adapt agents for the new stack's conventions
4. The `_shared/` protocols (autonomous-protocol, quality-gate) are stack-agnostic — reuse them

---

## Troubleshooting

**Agent stops and asks a question:**
The agent prompt still has a "stop and ask" pattern that was not converted to autonomous mode. Edit the agent file and replace the stop condition with the autonomous decision protocol from `_shared/autonomous-protocol.md`.

**PR has UNRESOLVED_BLOCKERS:**
The review loop exhausted its 5 iterations. Check the blockers in the PR description. Either fix them manually or re-run the pipeline with more specific clarification answers.

**Agent writes code that does not match codebase conventions:**
Update `rules/react-conventions.md` with the specific conventions the agent missed. Be explicit — agents follow exact instructions better than implicit expectations.

**Scope escalation:**
If an enhancement agent reclassifies to a feature, it means the scope was larger than expected. This is correct behavior — the feature pipeline provides the planning step that larger tasks need.
