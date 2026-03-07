# React + TypeScript Autonomous Agent Stack

Fully autonomous multi-agent pipelines for feature development, bug fixes, and enhancements in React + TypeScript codebases.

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
