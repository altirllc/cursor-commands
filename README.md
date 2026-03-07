# Autonomous Multi-Agent Orchestrator

A production-grade, fully autonomous multi-agent system for building and fixing React + TypeScript applications. Describe a task, answer clarity questions, walk away — receive a PR on GitHub.

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

## Architecture Overview

```
Task Description + Clarification Answers
                |
        [ Orchestrator ]
                |
    +-----------+-----------+
    |           |           |
 Feature    Bug Fix    Enhancement
 Pipeline   Pipeline    Pipeline
    |           |           |
    v           v           v
 Clarity    Investigate  Clarity
    |           |           |
  Plan        Plan      Implement
    |           |           |
 Implement   Implement   Test
    |           |           |
   Test       Test      Review ←--+
    |           |           |      |
  Review ←-+ Review ←-+ PR Desc  | (self-healing
    |      |    |      |          |  review loop)
 PR Desc   | PR Desc   +--→ Blocker Resolver
    |      |    |
    v      +----+--→ Blocker Resolver
  GitHub PR
```

Each pipeline shares:
- **Test Executor** — runs tests, classifies failures, auto-fixes test issues
- **PR Review** — fresh-context regression analysis with blocker classification
- **Blocker Resolver** — minimal fixes with fresh context (no original reasoning)
- **PR Description** — generates complete GitHub PR body

---

## Quick Start

### With Claude Code

1. Copy the repo into your project:
   ```
   cp -r stacks/ui/react/ .claude/agents/
   cp -r shared/ .claude/agents/_shared_global/
   ```

2. Point your `CLAUDE.md` to the orchestrator:
   ```
   See tools/claude-code.md for full setup instructions
   ```

3. Run a task:
   ```
   claude "Run the orchestrator for this task: [your task description]"
   ```

### With Cursor

1. Copy `stacks/ui/react/agents/` to `.cursor/commands/react/`
2. Commands appear when you type `/` in Cursor chat
3. Run agents manually in sequence following the workflow

---

## Workflows

| Task Type       | When to Use                            | Pipeline                                                          |
| --------------- | -------------------------------------- | ----------------------------------------------------------------- |
| **Feature**     | Large feature, 5+ files, new contracts | Clarity → Plan → Implement → Test → Review → PR                  |
| **Bug Fix**     | Something that worked is now broken    | Investigate → Plan → Implement → Test → Review → PR              |
| **Enhancement** | Small improvement, 1-4 files           | Clarity → Implement → Test → Review → PR                         |
| **Design UI**   | New UI that needs design decisions     | UI Scan (once) → Design UI (per feature, feeds into any pipeline) |

All workflows include the **self-healing review loop**: Test → Review → Blocker Resolve, up to 5 iterations.

---

## Directory Structure

```
.
├── README.md                          # This file
├── shared/
│   └── principles.md                  # 10 universal principles (all stacks)
├── tools/
│   ├── claude-code.md                 # Claude Code setup + usage guide
│   └── cursor.md                      # Cursor setup guide
└── stacks/
    └── ui/
        └── react/
            ├── README.md              # React stack documentation
            ├── _shared/               # Foundation (referenced by all agents)
            │   ├── autonomous-protocol.md
            │   ├── context-packet.md
            │   ├── handoff-format.md
            │   └── quality-gate.md
            ├── rules/                 # Project-specific (user customizes)
            │   ├── react-conventions.md
            │   └── memory.md
            ├── orchestrator/
            │   └── orchestrator.md    # Master state machine
            ├── workflows/
            │   ├── feature.md         # 9-phase feature pipeline
            │   ├── bug-fix.md         # 9-phase bug-fix pipeline
            │   └── enhancement.md     # 8-phase enhancement pipeline
            └── agents/
                ├── feature/
                │   ├── subagent-1-feature-clarity.md
                │   ├── subagent-2-feature-plan.md
                │   ├── subagent-3-implement.md
                │   └── subagent-4-test-checklist.md
                ├── bug-fix/
                │   ├── subagent-1-investigate.md
                │   ├── subagent-2-plan.md
                │   ├── subagent-3-implement.md
                │   └── subagent-4-test-checklist.md
                ├── enhancement/
                │   ├── subagent-1-feature-clarity.md
                │   ├── subagent-2-implement.md
                │   └── subagent-3-test-checklist.md
                ├── design-ui/
                │   ├── subagent-ui-scan.md
                │   └── subagent-design-ui.md
                ├── pr-review/
                │   └── subagent-pr-review.md
                ├── test-executor/
                │   └── test-executor.md
                ├── blocker-resolver/
                │   └── blocker-resolver.md
                └── pr-description/
                    └── pr-description.md
```

---

## Key Concepts

### Autonomous Operation
Every agent runs without human intervention. Ambiguities are resolved by: (1) checking clarification answers, (2) reading the codebase, (3) making the safer engineering judgment and documenting it as a `DECISION_POINT`.

### Structured Handoffs
Agents communicate via machine-readable handoff blocks with delimited sections (STATUS, SUMMARY, FILES_READ, etc.). This enables reliable orchestration and audit trails.

### Self-Healing Review Loop
```
Implement → Test Executor → PR Review → Blocker Resolver → Test Executor → ...
                                                              (max 5 loops)
```
Only BLOCKER-classified findings trigger the loop. Warnings, suggestions, and tech debt are noted but don't block.

### Fresh Context Principle
The Blocker Resolver and PR Review agents never see the original implementation reasoning. They receive only the diff, the spec, and the blocker list. Fresh eyes catch more bugs.

### Classification Gates
- Enhancement agents check if scope exceeds 4 files → auto-reclassify to Feature
- Bug fix investigation checks confidence → falls back to hypothesis-based approach

### Blocker Classification
| Level        | Triggers Fix Loop? | Examples                                    |
| ------------ | ------------------ | ------------------------------------------- |
| BLOCKER      | Yes                | Logic errors, runtime crashes, type breaks  |
| WARNING      | No                 | Missing loading states, perf concerns, a11y |
| SUGGESTION   | No                 | Naming preferences, code organization       |
| TECH_DEBT    | No                 | Issues too large for this PR                |

---

## Adding New Stacks

The architecture is stack-agnostic at the orchestrator and shared levels. To add a new stack (e.g., Python/FastAPI):

1. Create `stacks/backend/python/` mirroring the React structure
2. Write stack-specific agents referencing the same `_shared/` protocols
3. Add stack-specific `rules/` files
4. Create workflow definitions
5. The orchestrator routes based on task type, not stack

---

## Scaling

- **Parallel execution**: Use git worktrees for concurrent tasks (one worktree per task)
- **State persistence**: Each task gets a JSON state file for resumability
- **100+ tasks/day**: Orchestrator manages worktree lifecycle automatically

See `stacks/ui/react/orchestrator/orchestrator.md` for full state machine details.

---

## Portability

Copy the entire structure into any project. Customize:
- `rules/react-conventions.md` — your project's coding standards
- `rules/memory.md` — project-specific landmines and patterns
- Context packet fields — project name, conventions path, memory path
