# React + TypeScript Autonomous Agent Stack

Fully autonomous multi-agent pipelines for feature development, bug fixes, and enhancements in React + TypeScript codebases.

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

## Workflows

| Task Type       | When to Use                            | Pipeline                                                          |
| --------------- | -------------------------------------- | ----------------------------------------------------------------- |
| **Feature**     | Large feature, 5+ files, new contracts | Clarity → Plan → Implement → Test → Review → PR                   |
| **Bug Fix**     | Something that worked is now broken    | Investigate → Plan → Implement → Test → Review → PR               |
| **Enhancement** | Small improvement, 1-4 files           | Clarity → Implement → Test → Review → PR                          |
| **Design UI**   | New UI that needs design decisions     | UI Scan (once) → Design UI (per feature, feeds into any pipeline) |

All workflows include the **self-healing review loop**: Test → Review → Blocker Resolve, up to 5 iterations.

---

## Pipelines

### Feature Pipeline (9 phases)
For features touching 5+ files or requiring new TypeScript contracts.

1. **Clarity** (`agents/feature/subagent-1-feature-clarity.md`) — resolve ambiguities, classify scope
2. **Plan** (`agents/feature/subagent-2-feature-plan.md`) — impact analysis, TS contracts, PR split, implementation order
3. **Implement** (`agents/feature/subagent-3-implement.md`) — code with convention learning, restraint rules, auto-tests
4. **Test Checklist** (`agents/feature/subagent-4-test-checklist.md`) — manual browser test cases
5. **Test Executor** (`agents/test-executor/test-executor.md`) — run tests, classify failures, auto-fix
6. **PR Review** (`agents/pr-review/subagent-pr-review.md`) — fresh-context regression analysis
7. **Blocker Resolver** (`agents/blocker-resolver/blocker-resolver.md`) — minimal fixes, fresh context
8. **PR Description** (`agents/pr-description/pr-description.md`) — GitHub PR body
9. Review loop (phases 5-7 repeat up to 5x)

### Bug Fix Pipeline (9 phases)
For regressions and broken functionality.

1. **Investigate** (`agents/bug-fix/subagent-1-investigate.md`) — trace root cause, evidence-based
2. **Plan** (`agents/bug-fix/subagent-2-plan.md`) — minimal surgical fix design, caller mapping
3. **Implement** (`agents/bug-fix/subagent-3-implement.md`) — apply fix, write reproduction + regression tests
4. **Test Checklist** (`agents/bug-fix/subagent-4-test-checklist.md`) — 10-case manual checklist
5-9. Same shared phases (Test Executor → Review → Blocker Resolver → PR Description)

### Enhancement Pipeline (8 phases)
For small improvements touching 1-4 files.

1. **Clarity** (`agents/enhancement/subagent-1-feature-clarity.md`) — lightweight, with reclassification gate
2. **Implement** (`agents/enhancement/subagent-2-implement.md`) — scope guard (>4 files = escalation)
3. **Test Checklist** (`agents/enhancement/subagent-3-test-checklist.md`) — manual test cases
4-8. Same shared phases

### Design UI (optional, feeds into any pipeline)
- **UI Scan** (`agents/design-ui/subagent-ui-scan.md`) — run once per project
- **Design UI** (`agents/design-ui/subagent-design-ui.md`) — multiple design varieties from existing patterns

---

## Directory Structure

```
react/
├── README.md                          # This file
├── rules/                             # Project-specific (user customizes)
│   ├── react-conventions.md
│   └── memory.md
├── orchestrator/
│   ├── orchestrator.md                # Claude Code orchestrator (inline execution)
│   └── cursor-orchestrator.md         # Cursor command (→ .cursor/commands/)
└── agents/
    ├── _shared/                       # Foundation (referenced by all agents)
    │   ├── autonomous-protocol.md
    │   ├── context-packet.md
    │   ├── handoff-format.md
    │   └── quality-gate.md
    ├── setup/
    │   └── subagent-setup.md          # Phase 1: worktree + token (orchestrator invokes)
    ├── workflows/
    │   ├── feature.md                 # 9-phase feature pipeline
    │   ├── bug-fix.md                 # 9-phase bug-fix pipeline
    │   └── enhancement.md             # 8-phase enhancement pipeline
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

- **Cursor**: Real isolation — each subagent runs in its own context window
- **Claude Code**: Simulated — agent is instructed to ignore prior reasoning

### Classification Gates

- Enhancement agents check if scope exceeds 4 files → auto-reclassify to Feature
- Bug fix investigation checks confidence → falls back to hypothesis-based approach

### Blocker Classification

| Level      | Triggers Fix Loop? | Examples                                    |
| ---------- | ------------------ | ------------------------------------------- |
| BLOCKER    | Yes                | Logic errors, runtime crashes, type breaks  |
| WARNING    | No                 | Missing loading states, perf concerns, a11y |
| SUGGESTION | No                 | Naming preferences, code organization       |
| TECH_DEBT  | No                 | Issues too large for this PR                |

---

## Foundation Files

| File | Purpose |
| ---- | ------- |
| `_shared/autonomous-protocol.md` | Core autonomous operation rules, decision protocol, blocker self-resolution |
| `_shared/context-packet.md` | Template the orchestrator fills for every agent invocation |
| `_shared/handoff-format.md` | Universal handoff block format between agents |
| `_shared/quality-gate.md` | Anti-hallucination rules, security standards, performance standards |

---

## Customization

### Project-Specific Rules

- `rules/react-conventions.md` — your project's coding standards, file structure, naming
- `rules/memory.md` — project landmines, deprecated patterns, things agents must know

### Adding Agents

1. Create `agents/<category>/subagent-<name>.md`
2. Reference `_shared/` prerequisites
3. Include a structured handoff block
4. Add the agent to the relevant workflow in `workflows/`
5. Update the orchestrator if it's a new pipeline phase

---

## Agent Communication

Every agent:
- Reads `_shared/autonomous-protocol.md` for decision-making rules
- Receives a context packet from the orchestrator
- Outputs a structured handoff block (see `_shared/handoff-format.md`)
- Lists every file it read (anti-hallucination audit trail)
- Documents every autonomous decision as a `DECISION_POINT`

---

## Scaling

- **Parallel execution**: Use git worktrees for concurrent tasks (one worktree per task)
- **State persistence**: Each task gets a JSON state file for resumability
- **100+ tasks/day**: Orchestrator manages worktree lifecycle automatically

See `orchestrator/orchestrator.md` for full state machine details.
