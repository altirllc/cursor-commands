# Handoff Block Format

Every agent MUST produce a handoff block at the end of its output. The orchestrator parses these blocks to pass context between agents.

---

## Format

```
╔══════════════════════════════════════════════════════════════════╗
║  HANDOFF: {{AGENT_NAME}} → {{NEXT_AGENT_NAME}}                  ║
║  Task: {{TASK_ID}}                                               ║
║  Phase: {{PHASE_NUMBER}} of {{TOTAL_PHASES}}                     ║
╚══════════════════════════════════════════════════════════════════╝

━━━ STATUS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMPLETED | PARTIAL | BLOCKED

━━━ SUMMARY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[One paragraph — what this agent did and what the next agent needs to know]

━━━ OUTPUT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Agent-specific structured output — varies by agent type.
Each agent defines its own output sections in its prompt.]

━━━ DECISION POINTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every DECISION_POINT made during this phase — or "None"]

━━━ UNRESOLVED BLOCKERS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every UNRESOLVED_BLOCKER — or "None"]

━━━ FILES READ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every file opened and read during this phase]
- [exact file path]

━━━ FILES MODIFIED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every file created or changed — or "None (read-only phase)"]
- [exact file path] — [what changed]

━━━ NEXT AGENT INSTRUCTIONS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Specific instructions for the next agent in the pipeline.
What it should focus on. What it should NOT re-do.]
```

---

## Parsing Rules for the Orchestrator

1. The block starts at `╔══` and ends at the last `━━━` section's content.
2. STATUS determines routing:
   - COMPLETED → proceed to next phase
   - PARTIAL → proceed but flag in PR description
   - BLOCKED → route to blocker-resolver agent
   - FAILED → (setup agent only) halt pipeline, do not proceed; report error to user
3. UNRESOLVED BLOCKERS are collected across all phases and included in the final PR description.
4. DECISION POINTS are collected across all phases and included in the final PR description.
5. The full handoff block (OUTPUT section especially) is injected into the next agent's context packet as PREVIOUS PHASE OUTPUT.

---

## Agent-Specific Output Sections

Each agent type defines additional sections within the OUTPUT block. These are documented in each agent's prompt. The handoff format above is the universal wrapper — agent-specific content goes inside the OUTPUT section.
