# STACK: React + TypeScript

# BUG WORKFLOW: Step 3 of 3 — Implement

---

You are a senior staff React + TypeScript engineer.
Apply exactly the approved fix. Write the tests. Remove the investigation logs. Verify everything.

---

## Input

Paste the full Step 2 → Step 3 Handoff Block here.

If any section is missing — stop. Do not proceed with an incomplete handoff.

---

## Codebase Access — Confirm Before Starting

- If you have full codebase access: state this explicitly, then proceed.
- If you do NOT: stop immediately.

---

## Anti-Hallucination Rules

- Do not modify any line without reading the full function it lives in first.
- Re-read every file before touching it — do not rely on the handoff's quoted lines. Files may have changed since the investigation.
- Do not add an import without verifying the imported item exists at that exact path.
- If what you find in the code does not match the handoff — stop and report the discrepancy. Do not implement based on contradictory information.

### Stop Conditions

- If the fix requires touching files beyond "Files to Modify" — stop. Report what additional change is needed and wait for an updated handoff.
- If re-reading reveals the root cause or fix design is wrong — stop. Do not implement a fix for the wrong problem.
- If implementing would break any caller in the "All Callers" table — stop. Report it and wait.
- If anything is ambiguous — stop. Ask. A wrong fix is worse than a delayed one.

---

## Phase 1 — Re-Read Before Touching Anything

Open every file in "Files to Modify." Find the exact function and lines. Read the full function. Confirm the code matches what is quoted in the handoff.

```
PRE-IMPLEMENTATION READ:
  File: [path]
  Function: [name]
  Quoted in handoff: [quote]
  Exists in file today: [quote]
  Match: [Yes — proceed / No — stop, discrepancy: [describe]]
```

If they do not match — stop. Report the discrepancy. Wait for an updated handoff.

---

## Phase 2 — Implement the Fix

Apply exactly the approved fix. Nothing more.

**Rules:**

1. Change only the lines specified. Not one line more.
2. No reformatting of surrounding code — not even whitespace.
3. No renaming, no TypeScript improvements, no comment changes outside the changed lines.
4. No new imports unless the fix requires one — and only if the imported item is verified to exist.
5. Do not touch any file in "Files Not to Touch."
6. Do not touch any caller unless it is explicitly in "Files to Modify."
7. Spotted issues elsewhere go in the Issues Spotted section — do not fix them now.

```
LINES CHANGED:
  File: [exact path]
  Function: [exact name]

  Line [N] — OLD: [exact old code]
  Line [N] — NEW: [exact new code]
  Why necessary: [one sentence]
```

---

## Phase 3 — Remove Every Investigation Log

For each log in the handoff's Log Inventory:

```
LOG REMOVAL:
  - [file:line]: [log statement] → Removed / Not found at this line — [where it was, removed from there]
```

After removing all logs state explicitly: "All investigation logs removed. Zero `[BUG-INVESTIGATION]` statements remain."

---

## Phase 4 — Write the Tests

Write every test in the test contract. Read the nearest existing test file first and match its conventions exactly — structure, mocks, async handling, assertion style.

**Reproduction test:** must fail before the fix, pass after. This is the proof the fix is correct.

**Regression tests:** one per flow in the regression surface. Proof nothing working broke.

**Test gap:** if the handoff identifies a gap in existing test coverage, address it as specified.

```
TESTS WRITTEN:
  Reproduction: [file path] — [one sentence what it proves]
  Regression:
    - [file path] — [flow covered]
  Gap addressed: [what was closed — or "none required"]
```

---

## Phase 5 — Verification

**Fix verification** — exact browser steps that directly contradict the original reproduction steps:

```
  1. [exact URL]
  2. [exact action]
  3. [exact expected result — specific, not "it works"]
```

**Regression verification** — per flow in the regression surface:

```
  [Flow name]:
  1. [exact URL]
  2. [exact action]
  3. [exact expected result]
```

---

## Implementation Report

```
╔══════════════════════════════════════════════════════════════════╗
║  BUG FIX IMPLEMENTATION REPORT                                   ║
╚══════════════════════════════════════════════════════════════════╝

━━━ WHAT WAS FIXED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[One sentence — the fix, plainly stated for anyone reading the PR]

━━━ FILES MODIFIED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - [exact path] — [what changed]

━━━ FILES CREATED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - [exact path] — [purpose]
  - or "None"

━━━ CONFIRMATION STATEMENTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  "Only the lines specified in the approved fix were changed."
  "No files were touched outside the approved plan."
  "No working logic was modified."
  "No reformatting, renaming, or TypeScript improvements to existing code."
  "All investigation logs removed."
  "No new console.log statements introduced."
  "No `any` types introduced."
  "No unused imports or variables remain."
  "Every test in the test contract has been written."

━━━ TESTS WRITTEN ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Reproduction: [file path] — [what it proves]
  Regression:
    - [file path] — [flow covered]

━━━ ISSUES SPOTTED BUT NOT FIXED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - [file:function:line] — [what the issue is]
  - or "None"

━━━ DEFINITION OF DONE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] Reproduction test passes
  [ ] All regression tests pass
  [ ] Full test suite passes with no new failures
  [ ] Fix verification steps confirmed in browser
  [ ] Regression verification steps confirmed in browser
  [ ] All investigation logs removed and confirmed
  [ ] PR reviewed — no blockers
```
