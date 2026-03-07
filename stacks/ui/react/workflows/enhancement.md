# WORKFLOW: Enhancement

## Pipeline

```
Phase 1: CLARITY AGENT
  Agent: agents/enhancement/subagent-1-feature-clarity.md
  Mode: read-only
  Input: task description + clarification answers
  Output: clarity handoff (resolved requirements, classification)
  Gate: if reclassified as feature → switch to workflows/feature.md
        (all clarity work carries over — no duplication)

Phase 2: IMPLEMENT AGENT
  Agent: agents/enhancement/subagent-2-implement.md
  Mode: write
  Input: clarity handoff
  Output: implementation report, committed code
  Guard: if > 4 files needed → SCOPE_ESCALATION, switch to feature workflow

Phase 3: TEST EXECUTOR
  Agent: agents/test-executor/test-executor.md
  Mode: write (can fix test bugs)
  Input: implementation report + diff
  Output: test results + failure classification
  Gate: if FAIL_NEEDS_FIX → route to BLOCKER RESOLVER then re-test

Phase 4: PR REVIEW AGENT
  Agent: agents/pr-review/subagent-pr-review.md
  Mode: read-only (fresh context)
  Input: git diff + original task description ONLY
  Output: review verdict
  Gate: if BLOCKERS found → route to BLOCKER RESOLVER

Phase 5: BLOCKER RESOLVER (if needed)
  Agent: agents/blocker-resolver/blocker-resolver.md
  Mode: write (fresh context)
  Input: diff + blocker list + task description
  Output: fixes committed
  Then: loop back to Phase 3
  Loop limit: 5 total iterations

Phase 6: TEST CHECKLIST AGENT
  Agent: agents/enhancement/subagent-3-test-checklist.md
  Mode: read-only
  Input: task description + files modified
  Output: manual test checklist

Phase 7: PR DESCRIPTION AGENT
  Agent: agents/pr-description/pr-description.md
  Mode: read-only
  Input: all handoffs + decision points + test results
  Output: PR title + PR body

Phase 8: GIT OPERATIONS
  Mode: shell
  Actions:
    - git push origin {branch}
    - gh pr create --title "feat: {description}" --body "{body}"
  Output: PR URL
```

## Review Loop

Same as feature workflow. Max 5 iterations. Fresh context for each blocker-resolver call.

## Reclassification Gate

The clarity agent checks scope:
- If task touches 1-4 files, no shared utilities, no new TypeScript contracts → confirmed enhancement
- If task touches 5+ files OR modifies shared code OR needs new contracts → reclassified as feature

On reclassification:
1. Clarity output carries over (no re-work)
2. Pipeline switches to `workflows/feature.md` starting at Phase 2 (Plan Agent)
3. The plan agent receives the enhancement clarity output as its input

## Key Differences from Feature Workflow

1. **No planning step** — enhancements are small enough to go straight to code
2. **Scope guard** — implement agent stops if scope exceeds 4 files
3. **Lighter clarity** — fewer sections than feature clarity
4. **Always single PR** — enhancements are never split
5. **Fastest pipeline** — minimum agents for minimum scope

## Agent Count

- Standard: 6 agents
- Review loop adds: 2-3 agents per iteration
