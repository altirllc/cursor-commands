# WORKFLOW: Bug Fix

## Pipeline

```
Phase 1: INVESTIGATE AGENT
  Agent: agents/bug-fix/subagent-1-investigate.md
  Mode: read-only (may add console.log for investigation)
  Input: task description (bug details, reproduction steps, suspected area)
  Output: investigation handoff (root cause, execution path, ruled-out candidates)

Phase 2: FIX PLAN AGENT
  Agent: agents/bug-fix/subagent-2-plan.md
  Mode: read-only
  Input: investigation handoff
  Output: fix handoff with PLAN_READY_FOR_HUMAN_REVIEW (approved fix, files to modify, callers verified, test contract)
  Gate: PLAN APPROVAL GATE — orchestrator stops for human approval before implementation

Phase 3: IMPLEMENT AGENT
  Agent: agents/bug-fix/subagent-3-implement.md
  Mode: write
  Input: fix handoff
  Output: implementation report, committed code, investigation logs removed

Phase 4: TEST EXECUTOR
  Agent: agents/test-executor/test-executor.md
  Mode: write (can fix test bugs)
  Input: implementation report + diff
  Output: test results + failure classification
  Gate: if FAIL_NEEDS_FIX → route to BLOCKER RESOLVER then re-test

Phase 5: PR REVIEW AGENT
  Agent: agents/pr-review/subagent-pr-review.md
  Mode: read-only (fresh context)
  Input: git diff + original bug description ONLY
  Output: review verdict
  Gate: if BLOCKERS found → route to BLOCKER RESOLVER

Phase 6: BLOCKER RESOLVER (if needed)
  Agent: agents/blocker-resolver/blocker-resolver.md
  Mode: write (fresh context)
  Input: diff + blocker list + bug description
  Output: fixes committed
  Then: loop back to Phase 4
  Loop limit: 5 total iterations

Phase 7: TEST CHECKLIST AGENT
  Agent: agents/bug-fix/subagent-4-test-checklist.md
  Mode: read-only
  Input: bug description + fix applied + files touched
  Output: manual test checklist

Phase 8: PR DESCRIPTION AGENT
  Agent: agents/pr-description/pr-description.md
  Mode: read-only
  Input: all handoffs + decision points + test results (includes Phase 7 handoff)
  Output: PR title + PR body
  Guardrail: SEQUENTIAL — must run after Phase 7 completes. Do NOT run in parallel.

Phase 9: GIT OPERATIONS
  Mode: shell
  Actions:
    - git push origin {branch}
    - gh pr create --title "fix: {description}" --body "{body}"
  Output: PR URL
```

## Review Loop

Same as feature workflow. Max 5 iterations. Fresh context for each blocker-resolver call.

## Key Differences from Feature Workflow

1. **No clarity step** — bug reports come with reproduction steps, not requirements
2. **No planning step** — the investigation + fix plan replaces strategic planning
3. **Investigation is unique** — traces execution path, finds root cause with evidence
4. **Minimal fix principle** — change only what the bug requires, nothing more
5. **Always single PR** — bugs are never split into chunks
6. **Investigation logs tracked** — console.logs added during investigation must be removed

## Agent Count

- Standard: 7 agents
- Review loop adds: 2-3 agents per iteration
