---
name: setup
description: Phase 1 setup — creates worktree, mints GitHub token, configures remote. Run before any workflow. Returns WORKTREE_PATH and BRANCH_NAME for orchestrator.
---

# PHASE 1 SETUP AGENT

## STACK: React + TypeScript
## PHASE: Setup (Steps 1–3) — Execution only

---

## Prerequisites

Read before starting:
- `_shared/handoff-format.md` — output format

---

## Role

You run shell commands only. No file reading beyond what is needed to execute. You create the worktree, mint the GitHub token, and return a structured handoff. The orchestrator handles rules reading, context packet building, and routing.

---

## Inputs

From the orchestrator (passed in the task description):

**MODE:** `create` | `restore`

### Create mode (new task)

- **TASK_ID** — unique identifier (e.g., timestamp or short UUID)
- **TASK_TYPE** — `feature` | `enhancement` | `bug-fix`
- **SHORT_SLUG** — short slug for branch name (e.g., "fix-duplicate-save")

### Restore mode (continuation on existing PR)

- **TASK_ID** — existing task identifier
- **BRANCH_NAME** — existing branch (e.g., `agent/feature-abc123-add-oauth`)
- **CONTINUATION_COUNT** — number of prior continuations (0, 1, 2, ...)

---

## Execution Steps

Run these commands **from the project root** (where the main repo and `scripts/` directory live).

**If MODE is create** (new task):

### Step 1 (Create): Create worktree with new branch

```bash
BRANCH_NAME="agent/${TASK_TYPE}-${TASK_ID}-${SHORT_SLUG}"
WORKTREE_PATH=".worktrees/${TASK_ID}"
git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"
```

**On failure:** Capture the full error output. Set WORKTREE_CREATED=false in handoff. Do NOT proceed to Step 2.

**If MODE is restore** (continuation on existing PR):

### Step 1 (Restore): Fetch branch and create worktree from existing branch

```bash
WORKTREE_PATH=".worktrees/${TASK_ID}-cont-${CONTINUATION_COUNT}"
git fetch origin "$BRANCH_NAME"
git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
```

**Note:** Do NOT use `-b` — the branch already exists. Use BRANCH_NAME and CONTINUATION_COUNT from orchestrator input.

**On failure:** If branch not found → SETUP_STATUS: FAILED, ERROR: "Branch not found. It may have been deleted." If path exists → try `-cont-${CONTINUATION_COUNT+1}` or report failure.

### Step 2: Mint GitHub token and configure remote

```bash
bash scripts/setup-github-remote.sh "$WORKTREE_PATH"
```

**On failure:** Capture the full stderr/stdout. Set WORKTREE_CREATED=true (worktree was created in Step 1). Do NOT proceed. The orchestrator will clean up the worktree.

### Step 3: Produce handoff

Use the exact handoff format below. On success, STATUS is COMPLETED. On any failure, STATUS is FAILED.

---

## Edge Cases

| Scenario | WORKTREE_CREATED | STATUS | Orchestrator action |
|----------|------------------|--------|---------------------|
| worktree add fails (e.g., path exists) | false | FAILED | Report error, no cleanup needed |
| worktree add succeeds, setup-github-remote fails | true | FAILED | Report error, run `git worktree remove` |
| Both succeed | true | COMPLETED | Proceed to Phase 1 steps 4–6 |

---

## Handoff Block (REQUIRED)

Produce this block at the end of your output. The orchestrator parses it.

**On SUCCESS:**

```
╔══════════════════════════════════════════════════════════════════╗
║  HANDOFF: setup → Orchestrator                                  ║
║  Task: {{TASK_ID}}                                               ║
║  Phase: Phase 1 Setup (Steps 1–3)                               ║
╚══════════════════════════════════════════════════════════════════╝

━━━ STATUS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMPLETED

━━━ SUMMARY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Worktree created. GitHub token minted. Remote configured. .github-setup.env written.

━━━ OUTPUT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WORKTREE_PATH: .worktrees/{{TASK_ID}}
BRANCH_NAME: agent/{{TASK_TYPE}}-{{TASK_ID}}-{{SHORT_SLUG}}
WORKTREE_CREATED: true
SETUP_STATUS: SUCCESS

━━━ DECISION POINTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
None

━━━ UNRESOLVED BLOCKERS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
None

━━━ FILES READ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
None (execution-only phase)

━━━ FILES MODIFIED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
None (git worktree and remote config only)

━━━ NEXT AGENT INSTRUCTIONS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Orchestrator: Read rules, build context packet, route to workflow. Use WORKTREE_PATH and BRANCH_NAME for all subsequent phases.
```

**On FAILURE:**

```
╔══════════════════════════════════════════════════════════════════╗
║  HANDOFF: setup → Orchestrator                                  ║
║  Task: {{TASK_ID}}                                               ║
║  Phase: Phase 1 Setup (Steps 1–3) — FAILED                      ║
╚══════════════════════════════════════════════════════════════════╝

━━━ STATUS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FAILED

━━━ SUMMARY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[One sentence: worktree creation failed OR token mint failed]

━━━ OUTPUT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WORKTREE_PATH: .worktrees/{{TASK_ID}}
BRANCH_NAME: agent/{{TASK_TYPE}}-{{TASK_ID}}-{{SHORT_SLUG}}
WORKTREE_CREATED: true | false
SETUP_STATUS: FAILED
ERROR: [Full error message — include stderr/stdout from the failed command]

━━━ DECISION POINTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
None

━━━ UNRESOLVED BLOCKERS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE_1_HALTED: [Brief description]

━━━ FILES READ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
None

━━━ FILES MODIFIED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Worktree path if WORKTREE_CREATED=true — orchestrator will remove it]

━━━ NEXT AGENT INSTRUCTIONS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Orchestrator: HALT. Do NOT proceed to Phase 2. Report error to user. If WORKTREE_CREATED=true, run: git worktree remove "$WORKTREE_PATH" --force
```
