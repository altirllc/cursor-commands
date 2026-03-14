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

── PLAN APPROVAL (if re-invoke after Plan Approval Gate) ─────────
{{PLAN_APPROVAL}}  (approved | rejected | needs_context)
{{PLAN_FEEDBACK}}  (when rejected: specific feedback for plan refinement)
(or "None — first run or plan was approved")

When the human re-invokes after the Plan Approval Gate:
- approved: proceed to implementation
- rejected: plan agent runs again with PLAN_FEEDBACK to refine
- needs_context: plan agent runs again with additional context

── CONTINUATION CONTEXT (if this is a continuation run) ──────────
{{CONTINUATION_CONTEXT}}
(or "None — this is a new task or resume, not a continuation")

When the human re-invoked with "Continue TASK_ID=xyz. [new requirements]":
This section contains the new requirements for the existing PR. The task description
above reflects what to build in this continuation. Previous work (original PR) is done.

================================================================
```

---

## Rules for Agents Receiving This Packet

1. Read the full packet before starting any work.
2. If TASK DESCRIPTION is empty or unclear — mark as UNRESOLVED_BLOCKER per autonomous protocol.
3. If PREVIOUS PHASE OUTPUT is provided — use it as your primary input. Do not re-do work the previous agent already completed.
4. If BLOCKER CONTEXT is provided — you are in a fix cycle. Focus ONLY on resolving the listed blockers or test failures.
5. PROJECT CONVENTIONS and PROJECT MEMORY apply to every line of code you write. Read them. Follow them.
