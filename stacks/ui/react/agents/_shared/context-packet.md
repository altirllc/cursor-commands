# Context Packet Template

The orchestrator fills this template and injects it into every agent's prompt. Each agent receives ONLY this packet — nothing else.

---

```
================================================================
CONTEXT PACKET
================================================================

TASK ID: {{TASK_ID}}
TASK TYPE: {{TASK_TYPE}}  (feature | enhancement | bug-fix)
BRANCH: {{BRANCH_NAME}}
TIMESTAMP: {{TIMESTAMP}}

── TASK DESCRIPTION ─────────────────────────────────────────────
{{TASK_DESCRIPTION}}

── CLARIFICATION ANSWERS ────────────────────────────────────────
{{CLARIFICATION_QA}}
(or "None — task was fully specified")

When the human re-invokes after the Clarification Gate, they provide answers here.
Format: Q: A pairs. Clarity subagents MUST resolve BLOCKER_QUESTIONS from these before proceeding.

── PREVIOUS PHASE OUTPUT ────────────────────────────────────────
{{PREVIOUS_PHASE_HANDOFF_BLOCK}}
(or "None — this is the first phase")

── PROJECT CONVENTIONS ──────────────────────────────────────────
{{REACT_CONVENTIONS_MD_CONTENT}}

── PROJECT MEMORY ───────────────────────────────────────────────
{{MEMORY_MD_CONTENT}}

── BLOCKER CONTEXT (if this is a fix/resolve cycle) ─────────────
{{BLOCKER_LIST_OR_TEST_FAILURES}}
(or "None — this is not a fix cycle")

================================================================
```

---

## Rules for Agents Receiving This Packet

1. Read the full packet before starting any work.
2. If TASK DESCRIPTION is empty or unclear — mark as UNRESOLVED_BLOCKER per autonomous protocol.
3. If PREVIOUS PHASE OUTPUT is provided — use it as your primary input. Do not re-do work the previous agent already completed.
4. If BLOCKER CONTEXT is provided — you are in a fix cycle. Focus ONLY on resolving the listed blockers or test failures.
5. PROJECT CONVENTIONS and PROJECT MEMORY apply to every line of code you write. Read them. Follow them.
