# STACK: React + TypeScript

---

**BUG DESCRIPTION:**
User will provide {the original bug description — what the user saw, exact behaviour}

**ROOT CAUSE:**
User will provide {the confirmed root cause in one sentence}

**FIX APPLIED TO:**
User will provide {exact file path and function name where the fix was made}

**ADJACENT FILES TOUCHED:**
User will provide {any other files modified, or "none"}

---

## Anti-Hallucination Rules
- Base the checklist only on the bug, root cause, and fix described above.
- Do not invent test cases for flows unrelated to what was changed.
- If you are unsure which adjacent flows are at risk, ask — do not guess.

---

Give me exactly 10 manual browser test cases:
- Cases 1–3: confirm the bug is fixed (the exact scenario that was broken)
- Cases 4–6: confirm the most adjacent flows still work correctly
- Cases 7–9: edge cases specific to this fix (empty state, auth state, network error, rapid interaction, etc.)
- Case 10: the most likely regression scenario given what was changed

Format every item as:
```
[ ] Do X → Expect Y
```

Order by risk — highest risk first.
