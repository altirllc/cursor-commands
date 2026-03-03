# STACK: React + TypeScript

---

The UI for this feature should closely replicate the following existing pattern:

---

**FEATURE:**
User will provide {describe what needs to be built}

**EXISTING UI TO MIMIC:**
User will provide {exact file path or component name to replicate}

**SCOPE:**
User will provide {paste the list of new screens/components from Step 2 that this design covers}

---

## Anti-Hallucination Rules — Read Before Starting
- You must **read the existing component file** and every file it imports before producing any output.
- List every file you read at the top of your response.
- Do not describe props, state, or behaviour of the existing component from memory or inference — read the actual code.
- Do not assume a sub-component behaves a certain way — read it.

### Stop Condition
If you need more files to give a fully accurate design — read them. Do not produce output based on partial knowledge.

---

## Step 1 — Audit the Existing Component

Read the file, then document:
- Full component tree (what it renders and imports)
- Complete TypeScript props interface
- Internal state management
- Styling approach — list specific classes, patterns, or conventions
- Data dependencies — what it receives and from where

---

## Step 2 — Map the New Feature Onto the Existing Pattern

For each part of the new feature:
- What maps **directly** from the existing pattern? (reuse as-is)
- What needs **adjustment**? (extend or modify)
- What **cannot** reuse the existing pattern? (must be new — explain why)

---

## Step 3 — Component Plan

- Full component tree for the new feature
- Every new component with its complete TypeScript props interface
- Every existing component being reused, and from which file path
- Any shared types to be added to `types/`

---

## Step 4 — Gaps and Mismatches

Flag every place where the existing pattern doesn't cleanly fit the new feature's requirements. For each gap: propose a resolution that stays within the existing design system.

Wait for my confirmation before writing any code.
