# STACK: React + TypeScript

---

**WHAT THIS FEATURE DOES:**
User will provide {describe the feature and every user flow it enables}

**FILES CREATED:**
User will provide {list all new files created}

**EXISTING FILES MODIFIED:**
User will provide {list only pre-existing files that were changed — not new ones}

**PR SCOPE:**
User will provide {if this was a split PR, specify which chunk this test covers}

---

## Anti-Hallucination Rules
- Base all test cases only on the feature description and files listed above.
- Do not invent regression tests for flows unrelated to the changed files.
- If you are unsure which adjacent flows are at risk, ask — do not guess.

---

Give me a manual browser test checklist covering:

**Section 1 — New Feature (happy path)**
All primary scenarios where the new functionality works as expected.

**Section 2 — New Feature (edge cases)**
Empty data, loading state, error/network failure, unauthenticated user (if relevant), rapid/concurrent interaction, mobile viewport (if relevant).

**Section 3 — Regression Spot-Checks**
The existing flows most adjacent to the modified files that could have regressed.

**Section 4 — Browser Console**
Specific errors, warnings, or unexpected network requests I should watch for given this implementation.

Format every item as:
```
[ ] Do X → Expect Y
```

Order every section by risk — highest risk first.
