# WORKFLOW: Feature

## Pipeline

```
Phase 1: CLARITY AGENT
  Agent: agents/feature/subagent-1-feature-clarity.md
  Mode: read-only
  Input: task description + clarification answers
  Output: clarity handoff (resolved requirements, classification, decisions)
  Gate: if reclassified as enhancement → switch to workflows/enhancement.md

Phase 2: PLAN AGENT
  Agent: agents/feature/subagent-2-feature-plan.md
  Mode: read-only
  Input: clarity handoff
  Output: implement blocks (one per chunk)
  Gate: auto-approval (no human sign-off)

Phase 3: IMPLEMENT AGENT (per chunk, sequential)
  Agent: agents/feature/subagent-3-implement.md
  Mode: write
  Input: implement block for this chunk
  Output: implementation report, committed code
  Note: if multi-chunk, each chunk runs Phases 3-7 sequentially
        chunk N receives chunk N-1 handoff before starting

Phase 4: TEST EXECUTOR
  Agent: agents/test-executor/test-executor.md
  Mode: write (can fix test bugs)
  Input: implementation report + diff
  Output: test results + failure classification
  Gate: if FAIL_NEEDS_FIX → route to BLOCKER RESOLVER then re-test

Phase 5: PR REVIEW AGENT
  Agent: agents/pr-review/subagent-pr-review.md
  Mode: read-only (fresh context)
  Input: git diff + original task description ONLY
  Output: review verdict with blocker/warning/suggestion classification
  Gate: if BLOCKERS found → route to BLOCKER RESOLVER

Phase 6: BLOCKER RESOLVER (if needed)
  Agent: agents/blocker-resolver/blocker-resolver.md
  Mode: write (fresh context)
  Input: diff + blocker list + task description
  Output: fixes committed
  Then: loop back to Phase 4 (re-test → re-review)
  Loop limit: 5 total iterations (Phases 4-6 combined)

Phase 7: TEST CHECKLIST AGENT
  Agent: agents/feature/subagent-4-test-checklist.md
  Mode: read-only
  Input: implementation report + task description
  Output: manual test checklist for human QA

Phase 8: PR DESCRIPTION AGENT
  Agent: agents/pr-description/pr-description.md
  Mode: read-only
  Input: all handoffs + decision points + blockers + test results (includes Phase 7 handoff)
  Output: PR title + PR body markdown
  Guardrail: SEQUENTIAL — must run after Phase 7 completes. Do NOT run in parallel.

Phase 9: GIT OPERATIONS
  Mode: shell
  Actions:
    - git push origin {branch}
    - gh pr create --title "{title}" --body "{body}"
  Output: PR URL
```

## Review Loop Detail

```
         ┌──────────────────────────────────────────┐
         │           REVIEW LOOP (max 5)             │
         │                                           │
    ┌────┤  Phase 4: Test Executor                   │
    │    │  ├── PASS → Phase 5                       │
    │    │  └── FAIL → Blocker Resolver → re-test    │
    │    │                                           │
    │    │  Phase 5: PR Review                       │
    │    │  ├── SAFE → exit loop                     │
    │    │  └── BLOCKERS → Blocker Resolver → re-test│
    │    │                                           │
    │    │  After 5 iterations:                      │
    │    │  ├── WARNINGS only → proceed to PR        │
    │    │  └── BLOCKERS remain → PR with warnings   │
    │    └──────────────────────────────────────────┘
    │
    └── Each Blocker Resolver call uses FRESH context
```

## Multi-Chunk Handling

If the plan agent splits the feature into multiple chunks:

```
For chunk 1 of N:
  Run Phases 3-9 → creates PR #1

For chunk 2 of N:
  Receive chunk 1 handoff
  Run Phases 3-9 → creates PR #2

...

For chunk N of N:
  Receive chunk N-1 handoff
  Run Phases 3-9 → creates PR #N
```

Chunks are SEQUENTIAL, not parallel. Each chunk may depend on the previous chunk's code.

## Agent Count

- Single chunk: 8 agents
- Multi-chunk: 8 + (6 per additional chunk)
- Review loop adds: 2-3 agents per iteration
