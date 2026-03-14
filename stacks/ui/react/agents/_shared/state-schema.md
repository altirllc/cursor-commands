# Orchestrator State Schema

The orchestrator persists task state to `.orchestrator-state/{TASK_ID}.json`. This document defines the canonical schema and field documentation.

---

## Location

- **Path:** `.orchestrator-state/{TASK_ID}.json`
- **One file per task** — scales without write conflicts across parallel runs
- **Ignored by git** — `.orchestrator-state/` is added to `.gitignore` at orchestrator startup

---

## Schema

```json
{
  "taskId": "string",
  "branchName": "string",
  "worktreePath": "string | null",
  "taskDescription": "string",
  "taskType": "feature | enhancement | bug-fix",
  "shortSlug": "string",
  "currentPhase": "string",
  "status": "in_progress | completed",
  "createdAt": "string (ISO 8601)",
  "updatedAt": "string (ISO 8601)",
  "phases": {
    "setup": { "status": "completed", "completedAt": "string" },
    "clarity": { "status": "completed" },
    "plan": { "status": "completed" },
    "implement": { "status": "completed" }
  },
  "handoffs": {
    "clarity": "string",
    "plan": "string"
  },
  "clarificationAnswers": "object",
  "planApproval": "string | null",
  "planFeedback": "string | null",
  "decisionPoints": "array",
  "unresolvedBlockers": "array",
  "prUrl": "string | null",
  "continuationCount": "number"
}
```

---

## Field Documentation

| Field | Type | Purpose |
|-------|------|---------|
| `taskId` | string | Unique identifier. Used as resume/continuation key. Never changes. |
| `branchName` | string | Git branch for this task. e.g. `agent/feature-abc123-add-oauth`. |
| `worktreePath` | string \| null | Path to worktree. `null` after PR creation (worktree removed). Set again on continuation. |
| `taskDescription` | string | Original task description. On continuation, updated with new requirements. |
| `taskType` | string | `feature` \| `enhancement` \| `bug-fix`. Determines workflow. |
| `shortSlug` | string | Short slug for branch name. e.g. `add-oauth`. |
| `currentPhase` | string | Last phase reached. Used to resume from correct point. Values: `clarification_gate`, `plan_approval_gate`, `implement`, `review_loop`, `pr_created`. |
| `status` | string | `in_progress` — active task, worktree may exist. `completed` — PR created, use continuation to add more. |
| `createdAt` | string | ISO 8601 timestamp. When task was first created. |
| `updatedAt` | string | ISO 8601 timestamp. Last state write. |
| `phases` | object | Per-phase status and metadata. Used to skip completed phases on resume. |
| `phases.setup` | object | `{ status, completedAt }`. Setup complete. |
| `phases.clarity` | object | `{ status }`. Clarity handoff in `handoffs.clarity`. |
| `phases.plan` | object | `{ status }`. Plan handoff in `handoffs.plan`. |
| `phases.implement` | object | `{ status }`. Implement complete. |
| `handoffs` | object | **Single source** for handoff data. No duplication in `phases`. |
| `handoffs.clarity` | string | Full clarity handoff block. Injected as PREVIOUS_PHASE_OUTPUT for plan agent. |
| `handoffs.plan` | string | Full plan handoff block. Injected for implement agent. |
| `clarificationAnswers` | object | User's answers from clarification gate. Q:A pairs. |
| `planApproval` | string \| null | `approved` \| `rejected` \| `needs_context`. Set when user re-invokes after plan gate. |
| `planFeedback` | string \| null | User feedback when `planApproval: rejected`. Plan agent runs again with this. |
| `decisionPoints` | array | Collected across all phases. Included in PR description. |
| `unresolvedBlockers` | array | Collected across all phases. Included in PR description. |
| `prUrl` | string \| null | PR URL after creation. `null` until PR created. Used for continuation. |
| `continuationCount` | number | Incremented on each post-PR continuation. Used for worktree path: `.worktrees/{TASK_ID}-cont-{N}`. |

---

## State Lifecycle

1. **New task:** Create with `status: in_progress`, `worktreePath` set, `prUrl: null`, `continuationCount: 0`.
2. **Resume:** Load state, use `worktreePath`, skip setup. Continue from `currentPhase`.
3. **PR created:** Set `status: completed`, `prUrl`, `worktreePath: null`.
4. **Continuation:** Load state (`status: completed`). Restore worktree from `branchName`. Increment `continuationCount`. Set `status: in_progress`. New `worktreePath`: `.worktrees/{TASK_ID}-cont-{N}`.

---

## Atomic Writes

To avoid partial writes:

1. Write to `.orchestrator-state/{TASK_ID}.json.tmp`
2. On success, rename to `.orchestrator-state/{TASK_ID}.json`
3. On read, validate JSON; if invalid, treat as missing

---

## Validation on Read

- If file missing → treat as no state (new task or error)
- If JSON parse error → treat as corrupted, report error
- If required fields missing → treat as invalid, report error
