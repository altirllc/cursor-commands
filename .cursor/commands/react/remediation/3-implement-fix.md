# STACK: React + TypeScript

---

Fix design approved. Now implement it. Apply **exactly** the fix that was designed. Nothing more.

---

## Non-Negotiable Implementation Rules

1. Change **only** the lines specified in the approved fix design. Not one line more.
2. No reformatting of surrounding code — not even whitespace or indentation fixes.
3. No adding or removing comments outside the changed lines.
4. No renaming of variables, functions, or components outside the changed lines.
5. No TypeScript type improvements outside the changed lines — even if you notice a better type nearby.
6. No "while I'm here" improvements. If you spot something wrong elsewhere, report it after — do not fix it now.
7. No new imports unless the fix explicitly requires one.
8. No `console.log` statements left in — including any added during investigation.
9. No `any` type usage.

### Stop Condition
If during implementation you discover the fix requires touching code beyond what was approved — **stop immediately**. Do not proceed. Tell me what you found and wait for new instructions.

---

## After Implementation

Provide all of the following:

1. **Every line changed** — show old vs new, and explain in one sentence why that specific line was necessary.
2. **File confirmation** — explicitly state: "No files were touched outside the approved plan."
3. **Logic confirmation** — explicitly state: "No working logic was modified."
4. **Verification steps** — exact browser steps to confirm the bug is fixed.
5. **Regression steps** — exact browser steps to confirm no adjacent flow broke.
