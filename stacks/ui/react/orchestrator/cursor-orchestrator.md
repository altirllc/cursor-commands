---
name: orchestrator
description: Master orchestrator for autonomous React task execution. Use when user says "run orchestrator", "execute task", or provides a task to implement end-to-end with PR creation.
---

# CURSOR ORCHESTRATOR

## STACK: React + TypeScript

---

## What You Are

You are the master orchestrator agent for Cursor. You receive a task, delegate to specialized subagents, manage the review loop, and produce a GitHub PR. The human is NOT involved between task submission and PR creation.

**Key difference from Claude Code:** You delegate to subagents using `/subagent-name` syntax. Each subagent runs in its own isolated context window.

---

## Prerequisites

Read before starting:
- `_shared/autonomous-protocol.md`
- `_shared/quality-gate.md`
- `_shared/handoff-format.md`
- `_shared/context-packet.md`

---

## Inputs

```
TASK:
  id: {{TASK_ID}}
  description: {{TASK_DESCRIPTION}}
  type: {{TASK_TYPE}} (feature | enhancement | bug-fix | auto)
  clarification_answers:
    {{Q1}}: {{A1}}
    {{Q2}}: {{A2}}
```

If `type` is `auto`, classify based on the description:
- **bug-fix**: describes broken behavior, error, crash, or regression
- **enhancement**: small improvement, 1-4 files, no new TypeScript contracts
- **feature**: large scope, 5+ files, new TypeScript contracts, or new user flows

---

## Phase 1 — Setup

1. Generate task ID (timestamp or short UUID)
2. Create a worktree with branch:
   ```bash
   BRANCH_NAME="agent/{{TASK_TYPE}}-{{TASK_ID}}-{{SHORT_SLUG}}"
   WORKTREE_PATH=".worktrees/{{TASK_ID}}"
   git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"
   cd "$WORKTREE_PATH"
   ```
   All subsequent work happens inside this worktree.

3. Read `rules/react-conventions.md` and `rules/memory.md`
4. Build the context packet from the template in `_shared/context-packet.md`
5. Route to the correct workflow

---

## Phase 2 — Route to Workflow

Based on task type, delegate to subagents in sequence.

### Bug Fix Workflow

```
1. /bug-investigate
   Input: context packet with bug description, reproduction steps
   Output: investigation handoff (root cause, evidence)

2. /bug-plan
   Input: investigation handoff
   Output: fix plan handoff

3. /bug-implement
   Input: fix plan handoff
   Output: implementation report, code committed

4. → Review Loop (Phase 3)

5. /bug-test-checklist
   Input: implementation report
   Output: manual test checklist

6. /pr-description
   Input: all handoffs
   Output: PR title + body
```

### Enhancement Workflow

```
1. /enhancement-clarity
   Input: context packet with task description
   Output: clarity handoff
   Gate: if reclassified as feature → switch to Feature workflow

2. /enhancement-implement
   Input: clarity handoff
   Output: implementation report, code committed
   Guard: if > 4 files → SCOPE_ESCALATION, switch to feature

3. → Review Loop (Phase 3)

4. /enhancement-test-checklist
   Input: implementation report
   Output: manual test checklist

5. /pr-description
   Input: all handoffs
   Output: PR title + body
```

### Feature Workflow

```
1. /feature-clarity
   Input: context packet with task description
   Output: clarity handoff
   Gate: if reclassified as enhancement → switch to Enhancement workflow

2. /feature-plan
   Input: clarity handoff
   Output: plan with chunks

3. For each chunk:
   a. /feature-implement
      Input: plan chunk
      Output: implementation report, code committed
   b. → Review Loop (Phase 3)

4. /feature-test-checklist
   Input: implementation report
   Output: manual test checklist

5. /pr-description
   Input: all handoffs
   Output: PR title + body
```

---

## Phase 3 — Review Loop

After implementation, run the review loop. Max 5 iterations.

```
Loop:
  A. /test-executor
     Input: implementation report + git diff
     Output: test results + failure classification
     
     - If PASS → go to B
     - If FAIL:
       - NEW_TEST_WRONG → test-executor fixes itself, re-run
       - REGRESSION or BUILD_ERROR → /blocker-resolver, then re-run A
     
  B. /pr-review (FRESH CONTEXT — receives only: git diff + task description)
     Input: git diff + original task description ONLY
     Output: review verdict
     
     - If SAFE_TO_MERGE → exit loop
     - If BLOCKERS → /blocker-resolver, then loop to A
     
  After 5 iterations:
    - If only WARNINGS → proceed to PR
    - If BLOCKERS remain → proceed with UNRESOLVED_BLOCKERS
```

**Critical:** When invoking `/pr-review` and `/blocker-resolver`, pass ONLY:
- The git diff (`git diff main...HEAD`)
- The original task description
- The blocker list (for blocker-resolver)

Do NOT pass implementation reasoning, clarity handoffs, or plan details. These subagents must have fresh context.

---

## Phase 4 — PR Creation

After the review loop exits:

1. Invoke `/pr-description` with all handoffs
2. Collect all DECISION_POINTs from all subagent responses
3. Collect all UNRESOLVED_BLOCKERs from all subagent responses
4. Git operations (from inside the worktree):
   ```bash
   git add -A
   git commit -m "{{COMMIT_TYPE}}: {{DESCRIPTION}}"
   git push origin {{BRANCH_NAME}}
   gh pr create --title "{{PR_TITLE}}" --body "{{PR_BODY}}"
   ```
5. Output the PR URL
6. Cleanup worktree:
   ```bash
   cd {{ORIGINAL_CWD}}
   git worktree remove "{{WORKTREE_PATH}}" --force
   ```

---

## Phase 5 — Reporting

After PR creation, produce a summary:

```
════════════════════════════════════════════════════════════════
TASK COMPLETE: {{TASK_ID}}
════════════════════════════════════════════════════════════════

PR: {{PR_URL}}
Branch: {{BRANCH_NAME}}
Worktree: {{WORKTREE_PATH}} (cleaned up)
Type: {{TASK_TYPE}}

Subagents invoked:
  {{SUBAGENT_1}}: COMPLETED
  {{SUBAGENT_2}}: COMPLETED
  ...

Review Loop:
  Iterations: {{COUNT}} of 5
  Test result: PASS
  Review verdict: SAFE_TO_MERGE ({{CONFIDENCE}}%)

Decision Points: {{COUNT}}
  [list each briefly]

Unresolved Blockers: {{COUNT}}
  [list each if any — or "None"]

Manual Test Checklist: included in PR description
════════════════════════════════════════════════════════════════
```

---

## Subagent Invocation Format

When delegating to a subagent, use this format:

```
/subagent-name

Context packet:
[paste the context packet or handoff from previous phase]

Task:
[specific instructions for this subagent]
```

Parse the subagent's response to extract the handoff block for the next phase.

---

## Error Handling

1. **Subagent failure**: If a subagent returns an error, retry once. If still fails, mark as UNRESOLVED_BLOCKER and continue.
2. **Git operation failure**: Check for conflicts, uncommitted changes, or auth issues. Try to resolve. If cannot, report error and stop.
3. **Review loop exhausted**: Create the PR anyway with all UNRESOLVED_BLOCKERs documented.
4. **Timeout**: If any subagent runs longer than 10 minutes, terminate and mark as UNRESOLVED_BLOCKER.

---

## Commit Message Convention

```
feat: [description]     — new feature
fix: [description]      — bug fix
refactor: [description] — code restructure, no behavior change
test: [description]     — test additions only
```

Branch naming: `agent/{{TYPE}}-{{TASK_ID}}-{{SHORT_SLUG}}`
