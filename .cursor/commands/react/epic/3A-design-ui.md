# STACK: React + TypeScript

---

Before writing any production code, design the full UI for this feature.

---

**FEATURE:**
User will provide {paste the full feature description with all clarified requirements}

**SCOPE:**
User will provide {paste the exact list of new screens and components identified in Step 2}

**APPROVED PR SPLIT:**
User will provide {paste the PR strategy decided in Step 2 — which PR is this design for?}

---

## Anti-Hallucination Rules — Read Before Starting
- Do not reference any existing component unless you have read its file in this session.
- Do not assume what styling system is used — read a few existing components first.
- Do not assume what TypeScript patterns are used for props — read existing component interfaces.
- List every file you read at the top of your design output.
- If a component you want to reuse has props or behaviour you are not sure about — read it before referencing it.

### Stop Condition
If you need more files to produce an accurate design — read them. Do not design from incomplete knowledge.

---

## Design Rules
- Study the existing codebase before designing. Understand: component structure, styling approach, spacing, naming conventions, TypeScript prop patterns.
- Every new component must feel **native** to the existing app.
- Reuse existing components wherever possible — never recreate what already exists.
- If a new component is needed, define its full TypeScript props interface before anything else.

---

## Produce (no code yet)

**Start by listing every existing file you read to inform this design.**

Then output:

1. **UI description** — plain English of every new screen or section the user will see
2. **Component inventory:**
   - Reused as-is: [ComponentName] from [file path]
   - Extended/modified: [ComponentName] — what changes and why
   - New: [ComponentName] — purpose + full TypeScript props interface
3. **Component tree** — full parent → child hierarchy
4. **State design** — what state exists, where it lives (local / context / server state), and why
5. **Data dependencies** — what API data is needed, where it enters the tree, and what the TypeScript shape is
6. **TypeScript contracts** — any shared types or interfaces that need to be created in `types/`

I will review and approve this design before implementation starts.
