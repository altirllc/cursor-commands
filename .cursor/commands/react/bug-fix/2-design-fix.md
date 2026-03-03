# STACK: React + TypeScript

---

Root cause confirmed. Now design the fix. You are still not allowed to write any code.

---

**CONFIRMED ROOT CAUSE:**
User will provide {the exact root cause from Step 1 — one sentence, with file, function, and line}

---

## Anti-Hallucination Rules — Read Before Starting
- Do not propose a fix for code you haven't read in this session. If you need to re-read a file, do it now.
- Every claim about "what this fix will affect" must be backed by evidence from the actual code — not assumptions about what the code probably does.
- If you discover during design that you need to read an additional file to be certain — read it. State that you read it.
- If you are working from an assumption rather than evidence, label it: `[ASSUMPTION — unverified]`.

### Stop Condition
If at any point the fix design requires you to assume something about code you haven't read — stop. Tell me what file you need to read before continuing.

---

## Before Proposing the Fix

1. Restate the exact root cause in one sentence.
2. Identify the precise file, function, and lines affected — cite them.
3. Explain the full broken execution path from user action to failure point.
4. Explain why every other execution path is NOT involved — with evidence.

---

## Fix Design

Answer each of these before describing the fix:
- What is the **minimal change** that resolves exactly this root cause?
- Why is this fix safer than any alternative approach?
- What could go wrong with this fix?
- Does this fix affect any other caller of the modified function or component? Check by searching for all usages.

---

## Constraints — Non-Negotiable

- Zero regression risk
- No behavioural change outside the broken scenario
- No performance impact
- No new dependencies
- No refactors
- No defensive rewrites of working code
- No changes to working logic
- No TypeScript `any` shortcuts
- The fix must be explainable in 1–2 sentences. If it can't be, it is too complex — redesign it.

---

## End Your Response With

```
Files to be modified: [list]
Lines to be changed: [list]
Other callers of modified code: [list — or "none found"]
Confidence this fix is fully isolated: [X]%
```

> If confidence is below 90%, tell me exactly what is making you uncertain before we proceed.
