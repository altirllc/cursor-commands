# STACK: React + TypeScript

# BUG WORKFLOW: Step 2 of 3 — Fix Design

---

You are not allowed to write, modify, or delete any code in this step.

---

## Input

Paste the full Step 1 → Step 2 Handoff Block here.

If the handoff block is missing the root cause, execution path, ruled-out candidates, or log inventory — stop and ask for a complete handoff before continuing.

---

## Codebase Access — Confirm Before Starting

- If you have full codebase access: state this explicitly, then proceed.
- If you do NOT: stop immediately. Fix design requires reading the actual code.

---

## Anti-Hallucination Rules

- Do not propose a fix for code you have not opened and read in this session. Even if the handoff quotes lines — re-read the full function before designing a fix for it.
- Do not claim a fix is isolated without reading every caller of the modified code.
- Do not claim no regression risk without reading the adjacent flows that touch the same files.
- Every claim must cite exact file path + function name + line number.
- If you are working from an assumption rather than evidence, label it: `[ASSUMPTION — unverified]`
- If you find anything that contradicts the Step 1 handoff — stop immediately and report the discrepancy. Do not design a fix based on a contradiction.

### Stop Conditions

- If the root cause in the handoff is incorrect or incomplete after re-reading the code — stop. Report what you found and return to Step 1.
- If the fix requires changing more than the identified root cause location — stop. State exactly what additional scope is needed and get explicit approval before expanding.
- If any caller of the modified code would be broken by the fix — stop. The fix must address this before proceeding.

---

## Phase 1 — Re-Read and Verify the Root Cause

Re-read the code yourself. Do not trust the handoff quotes alone.

1. Open every file listed in the handoff's "Files Read."
2. Find the exact function and line identified as the root cause.
3. Read the full function — not just the identified lines.
4. Confirm the root cause is exactly correct.

```
ROOT CAUSE VERIFIED:
  File re-read: [yes/no]
  Lines as they exist today: [quote exactly from the file]
  Matches handoff: [yes / no — if no, stop and report discrepancy]
  Why these lines cause the failure: [precise technical explanation]
```

---

## Phase 2 — Find Every Caller of the Code Being Modified

This is the most critical phase. A fix that is correct in isolation but breaks a caller is a production bug.

Search the entire codebase for every place the modified function, hook, component, or utility is imported or called. Read every caller. Assess whether the fix is safe for each one individually.

```
ALL CALLERS OF [modified code]:

| File | Function/Component | How it calls the modified code | Safe after fix: Yes/No | Reason |
|------|--------------------|-------------------------------|------------------------|--------|
| [path] | [name] | [how] | [yes/no] | [why] |

CALLERS WHERE FIX CAUSES A PROBLEM:
  - [file:function] — [exact problem]
  - or "None — fix is safe for all callers"
```

If any caller is affected — the fix design must explicitly address it. A fix that breaks a caller cannot proceed.

---

## Phase 3 — Map the Regression Surface

For each file being changed, identify what user-facing flows pass through it and what state it reads or writes.

```
REGRESSION SURFACE:

File: [path]
  User flows through this file: [list]
  State read/written: [what — or "none"]
  Components depending on that state: [list — or "none"]

Flows at risk:
  - [flow name]: [why at risk] — [file:function where risk lives]
  - or "None beyond direct callers"
```

This becomes the regression test targets and regression verification steps in Step 3.

---

## Phase 4 — Design the Fix

Answer every question before describing the fix:

- What is the **minimal change** that resolves exactly this root cause? State it in one sentence. If it cannot be stated in one sentence — it is too complex, redesign.
- Why is this safer than any alternative? Name at least one alternative and explain why it was rejected.
- What could go wrong with this fix? Be specific — exactly which file, flow, scenario.
- Does this fix change any behaviour outside the broken scenario? If yes — redesign until the answer is no.
- Does this fix introduce new dependencies or require refactoring working code? If yes — redesign.

```
FIX DESCRIPTION:
  What changes: [file, function, lines — old behaviour, new behaviour]
  Why this resolves the root cause: [precise technical explanation]
  Why this is fully isolated: [evidence nothing outside the broken scenario changes]
```

---

## Phase 5 — Test Contract

Every bug fix requires two things:

1. **A reproduction test** — fails before the fix, passes after. This is the automated proof the fix is correct.
2. **Regression tests** — one per flow in the regression surface, proving nothing working broke.

If existing tests should have caught this bug and didn't — explain why and state what gap gets closed.

```
REPRODUCTION TEST:
  File: [exact path]
  Type: Unit / Integration / E2E
  Setup: [exact state and conditions]
  Action: [exact trigger]
  Assertion before fix: [must FAIL]
  Assertion after fix: [must PASS]
  Mocks needed: [or "none"]

REGRESSION TESTS:
  - Flow: [name] | File: [path] | Asserts: [what must remain true]

WHY EXISTING TESTS MISSED THIS:
  [explanation]
  Action required: [what gap is closed in this fix — or "tracked separately: [reason]"]
```

---

## Handoff Block

Produce this after completing all phases. Step 3 takes only this block as input. The implementer has no access to this session.

```
╔══════════════════════════════════════════════════════════════════╗
║  BUG FIX HANDOFF — Step 2 → Step 3                              ║
╚══════════════════════════════════════════════════════════════════╝

━━━ BUG SUMMARY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Full bug description and reproduction steps — do not abbreviate]

━━━ CONFIRMED ROOT CAUSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
One sentence: [what is wrong]
File:         [exact path]
Function:     [exact name]
Lines:        [exact numbers]
Code (exact): [quoted from file]
Why it fails: [precise technical explanation]

━━━ APPROVED FIX ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Exact description — old code, new code, why. Specific enough
that there is only one way to implement this.]

In one sentence: [the fix, plainly stated]

━━━ FILES TO MODIFY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - [exact path] — [what changes and exactly where]

━━━ FILES NOT TO TOUCH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - [exact path] — [why it does not need to change]

━━━ ALL CALLERS VERIFIED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  | File | How it calls modified code | Safe: Yes/No | Notes |

━━━ REGRESSION SURFACE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - [flow name]: [why at risk] — [file where risk lives]
  - or "None beyond direct callers — all verified safe"

━━━ TEST CONTRACT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Complete reproduction test and regression tests from Phase 5]

━━━ LOG INVENTORY TO REMOVE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every console.log from Step 1. Implementer removes every one.]
  - [file path] line [N]: [exact log statement]
  - or "None added during investigation"

━━━ WHAT MUST NOT HAPPEN DURING IMPLEMENTATION ━━━━━━━━━━━━━━━━━━
[Explicit constraints derived from the investigation — e.g.
"do not change the function signature — 4 callers depend on it"]
  - [constraint]: [why]
```
