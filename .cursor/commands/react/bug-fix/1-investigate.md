# STACK: React + TypeScript

# BUG WORKFLOW: Step 1 of 3 — Investigate

---

You are not allowed to write or modify any code in this step.
The only exception: `console.log` statements added strictly to gather missing runtime evidence.

---

## Inputs

**BUG DESCRIPTION:**
User will provide {exact description of what the user sees}

**STEPS TO REPRODUCE:**
User will provide {exact numbered steps}

**SUSPECTED AREA:**
User will provide {file or component suspected — write "unknown" if unsure}

**ENVIRONMENT:**
User will provide {where this happens — e.g. "production only", "all environments", "only on Safari"}

---

## Codebase Access — Confirm Before Starting

- If you have full codebase access: state this explicitly, then proceed.
- If you do NOT: stop immediately. Do not proceed. Do not describe what you think the code contains.

---

## Anti-Hallucination Rules

- Do not describe how any code works unless you have read the actual file.
- Do not infer behaviour from file names or component names alone.
- Every claim must reference a specific file, function, and line number.
- If you are working from an assumption rather than evidence, label it: `[ASSUMPTION — unverified]`

### Stop Condition

If at any point you reach a decision where you would need to assume something you cannot verify from the code — stop immediately. Tell me what you need before continuing.

---

## Investigation Steps

1. List every file you are about to read before you read them.
2. Read those files. Trace the full execution path from user action to failure point.
3. Identify every candidate root cause.
4. For each candidate: what exact evidence **confirms** it or **eliminates** it? Cite file + line.
5. Do not stop at the surface level. Go deep until you are certain.
6. If you cannot confirm the root cause from code alone, add `console.log` statements that emit JSON stringified output so we can get the evidence we need. Prefix every log with `[BUG-INVESTIGATION]`. Use the minimum number of logs needed.

---

## Output

Only when you are 100% confident, state:

- **Root cause:** one sentence
- **File:** exact path
- **Function:** exact name
- **Line:** exact number
- **Evidence:** quote the relevant lines and explain why they cause the bug

**Ruled out** — document every candidate that was investigated and eliminated, with the evidence that eliminated it. This travels to Step 2 so the fix designer does not re-investigate dead ends.

- [candidate]: eliminated because [file:function:line — exact evidence]

> If confidence is below 90%, do not state a root cause. Add the JSON stringified logs instead and provide exact reproduction steps so I can collect the output.

---

## Handoff Block

Produce this after completing the investigation. Step 2 takes only this block as input.

```
╔══════════════════════════════════════════════════════════════════╗
║  BUG INVESTIGATION HANDOFF — Step 1 → Step 2                    ║
╚══════════════════════════════════════════════════════════════════╝

━━━ BUG DESCRIPTION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Full bug description and reproduction steps — do not summarise]

━━━ CONFIRMED ROOT CAUSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
One sentence: [what is wrong]
File:         [exact path]
Function:     [exact name]
Line:         [exact number]
Evidence:     [relevant lines quoted exactly, with explanation]

━━━ EXECUTION PATH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Full path from user action to failure — every node confirmed
by code, with file:function:line for each]

━━━ RULED OUT — DO NOT RE-INVESTIGATE ━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every candidate eliminated, with the evidence that eliminated it]
  - [candidate]: [file:function:line — exact evidence]

━━━ FILES READ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - [exact file path]

━━━ LOG INVENTORY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every console.log added. Step 3 removes every one of these.]
  - [file path] line [N]: [exact log statement]
  - or "None — root cause confirmed from code alone"

━━━ OPEN QUESTIONS FOR FIX DESIGNER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - or "None"
```
