# AUTONOMOUS ORCHESTRATOR

## STACK: React + TypeScript

---

## What You Are

You are the master orchestrator agent. You receive a task, route it through the correct workflow pipeline, manage the review loop, and produce a GitHub PR. The human is NOT involved between task submission and PR creation.

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

1. Create a worktree with a new branch:
   ```bash
   BRANCH_NAME="agent/{{TASK_TYPE}}-{{TASK_ID}}-{{SHORT_SLUG}}"
   WORKTREE_PATH=".worktrees/{{TASK_ID}}"
   git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"
   cd "$WORKTREE_PATH"
   ```
   All subsequent work happens inside this worktree. The main working directory stays clean.

2. **Mint GitHub token and configure git remote:**
   ```bash
   # Save original remote URL for later restoration
   ORIGINAL_REMOTE=$(git remote get-url origin)
   
   # Mint installation access token (valid for 1 hour)
   GITHUB_TOKEN=$(bash scripts/mint-github-token.sh)
   
   # Derive org/repo from remote URL
   if [[ "$ORIGINAL_REMOTE" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
     ORG="${BASH_REMATCH[1]}"
     REPO="${BASH_REMATCH[2]}"
   fi
   
   # Set remote to use token for push operations
   git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${ORG}/${REPO}.git"
   ```

3. Read `rules/react-conventions.md` and `rules/memory.md`
4. Build the context packet from the template in `_shared/context-packet.md`
5. Route to the correct workflow

---

## Phase 2 — Route to Workflow

Based on task type, execute the corresponding workflow:

### Bug Fix (`workflows/bug-fix.md`)
```
1. Investigate Agent      (read-only)
2. Fix Plan Agent         (read-only)
3. Implement Agent        (write)
4. → Review Loop
```

### Enhancement (`workflows/enhancement.md`)
```
1. Clarity Agent          (read-only)
   → If reclassified as feature → switch to Feature workflow
2. Implement Agent        (write)
3. → Review Loop
```

### Feature (`workflows/feature.md`)
```
1. Clarity Agent          (read-only)
2. Plan Agent             (read-only)
3. For each chunk:
   a. Implement Agent     (write)
   b. → Review Loop
   c. Create PR for this chunk
```

---

## Phase 3 — Review Loop

After implementation, run the review loop. This is the quality gate that replaces human oversight.

```
┌─────────────────────────────────────────────────────────┐
│                    REVIEW LOOP                           │
│                                                          │
│  Step A: TEST EXECUTOR AGENT                             │
│  ├── Run test suite                                      │
│  ├── If PASS → go to Step B                              │
│  ├── If FAIL:                                            │
│  │   ├── Classify failure                                │
│  │   ├── If NEW_TEST_WRONG → test executor fixes itself  │
│  │   ├── If REGRESSION or BUILD_ERROR:                   │
│  │   │   └── BLOCKER RESOLVER AGENT (fresh context)      │
│  │   │       ├── Fix the issue                           │
│  │   │       ├── Commit fix                              │
│  │   │       └── Loop back to Step A                     │
│  │   └── Max 5 total fix attempts                        │
│  │                                                       │
│  Step B: PR REVIEW AGENT (fresh context, diff only)      │
│  ├── 6-phase review                                      │
│  ├── Produce VERDICT block                               │
│  ├── If SAFE_TO_MERGE: YES → exit loop                   │
│  ├── If BLOCKERS found:                                  │
│  │   └── BLOCKER RESOLVER AGENT (fresh context)          │
│  │       ├── Fix each blocker                            │
│  │       ├── Commit fixes                                │
│  │       └── Loop back to Step A                         │
│  └── Max 5 total loop iterations (test + review combined)│
│                                                          │
│  After 5 loops with unresolved issues:                   │
│  ├── If only WARNINGS remain → proceed to PR             │
│  └── If BLOCKERS remain → proceed to PR with             │
│       UNRESOLVED_BLOCKERS section prominently displayed  │
└─────────────────────────────────────────────────────────┘
```

**Loop counter rules:**
- Test failure fix attempt = 1 iteration
- Review blocker fix attempt = 1 iteration
- Total across both: max 5
- Each fix attempt uses a FRESH blocker-resolver context (no bias from previous attempts)

---

## Phase 4 — PR Creation

After the review loop exits:

1. Run **Test Checklist Agent** → produces manual test checklist
2. Run **PR Description Agent** → produces structured PR body
3. Collect all DECISION_POINTs from all phases
4. Collect all UNRESOLVED_BLOCKERs from all phases
5. Git operations (from inside the worktree):
   ```bash
   git add -A
   git commit -m "{{COMMIT_TYPE}}: {{DESCRIPTION}}"
   git push origin {{BRANCH_NAME}}
   
   # Create PR via GitHub API (using token from Phase 1)
   PR_URL=$(bash scripts/github-create-pr.sh "{{BRANCH_NAME}}" "{{PR_TITLE}}" "{{PR_BODY}}" "develop")
   ```
6. Output the PR URL
7. Restore original remote URL and cleanup worktree:
   ```bash
   # Restore original remote URL
   git remote set-url origin "$ORIGINAL_REMOTE"
   
   cd {{ORIGINAL_CWD}}
   git worktree remove "{{WORKTREE_PATH}}" --force
   ```
   The branch remains on the remote; only the local worktree is removed.

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

Pipeline:
  {{PHASE_1}}: COMPLETED
  {{PHASE_2}}: COMPLETED
  {{PHASE_N}}: COMPLETED

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

## Error Handling

If the orchestrator itself encounters an error:

1. **Agent spawn failure**: retry once. If still fails, skip to next phase that does not depend on the failed agent. Mark as UNRESOLVED_BLOCKER.
2. **Git operation failure**: check for conflicts, uncommitted changes, or auth issues. Try to resolve. If cannot, report error and stop.
3. **All agents fail in the review loop**: create the PR anyway with all UNRESOLVED_BLOCKERs documented. The human decides.
4. **Timeout**: if any agent runs longer than 10 minutes, terminate and mark as UNRESOLVED_BLOCKER.

---

## GitHub API Guardrails

**CRITICAL: The GitHub token is scoped and must only be used for specific operations.**

### Allowed Operations

The GitHub token may ONLY be used for:

1. **Pushing commits** — `git push origin {{BRANCH_NAME}}`
2. **Creating PRs** — via `scripts/github-create-pr.sh` ONLY

### Forbidden Operations

DO NOT use the GitHub token or call any GitHub API for:

- Creating, closing, or updating issues
- Deleting branches or tags
- Modifying repository settings
- Managing webhooks or integrations
- Accessing other repositories
- Any API endpoint not explicitly listed in "Allowed Operations"

### Implementation Rules

1. **No direct API calls** — Always use the provided scripts (`mint-github-token.sh`, `github-create-pr.sh`)
2. **No token exposure** — Never log, print, or include the token in any output
3. **No token reuse** — Each task mints its own token; do not cache or share tokens between tasks
4. **Fail safely** — If a GitHub operation fails, report the error and stop; do not retry with different API calls

---

## Parallel Execution (Multiple Tasks)

Every task runs in its own worktree by default (see Phase 1). This enables parallel execution without conflicts.

When running multiple tasks simultaneously:

- Each task runs in its own git worktree: `.worktrees/{{TASK_ID}}/`
- Each task has its own branch, state, and agent chain
- No cross-talk between tasks
- Conflict resolution happens at PR merge time on GitHub (same as real dev teams)

To run N tasks in parallel, start N orchestrator instances (e.g., N terminals or N `claude` processes):
```
# Terminal 1
claude "Run orchestrator: task-1 description"

# Terminal 2
claude "Run orchestrator: task-2 description"

# ...each creates its own worktree and runs independently
```

Each instance follows the same flow: create worktree → run pipeline → create PR → cleanup worktree.

---

## Commit Message Convention

```
feat: [description]     — new feature
fix: [description]      — bug fix
refactor: [description] — code restructure, no behavior change
test: [description]     — test additions only
```

Branch naming: `agent/{{TYPE}}-{{TASK_ID}}-{{SHORT_SLUG}}`

---

## State Persistence

For resumability, maintain a state file per task:

```json
{
  "taskId": "{{TASK_ID}}",
  "type": "{{TASK_TYPE}}",
  "branch": "{{BRANCH_NAME}}",
  "worktreePath": "{{WORKTREE_PATH}}",
  "originalCwd": "{{ORIGINAL_CWD}}",
  "currentPhase": "{{PHASE_NAME}}",
  "loopCount": 0,
  "maxLoops": 5,
  "phases": {
    "clarity":   { "status": "completed", "handoff": "..." },
    "plan":      { "status": "completed", "handoff": "..." },
    "implement": { "status": "in-progress" },
    "test":      { "status": "pending" },
    "review":    { "status": "pending" },
    "pr":        { "status": "pending" }
  },
  "decisionPoints": [],
  "unresolvedBlockers": []
}
```

If interrupted, resume from the last incomplete phase. On resume, `cd` into `worktreePath` before continuing.
