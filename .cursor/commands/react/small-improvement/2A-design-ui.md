# STACK: React + TypeScript

---

All requirements are clear. Before writing any production code, design the UI for this feature.

---

**FEATURE:**
User will provide {paste the feature description + all clarified answers from Step 1}

---

## Anti-Hallucination Rules — Read Before Starting
- Do not describe or reference any existing component unless you have **read that component's file** in this session.
- List every file you read before producing your design output.
- Do not invent component names that sound like they might exist — verify they exist.
- Do not assume a styling pattern (Tailwind class, CSS module, styled-component) is used unless you have seen it in the actual files.
- If you cannot find the design system or component library being used, say so — do not assume.

### Stop Condition
If you need to read more files to give an accurate design, read them first. Do not produce output based on incomplete codebase knowledge.

---

## Design Rules
- Study the existing codebase before designing anything. Understand: component structure, styling approach (Tailwind / CSS Modules / styled-components), spacing conventions, naming conventions, TypeScript prop patterns.
- The new UI must feel **native** to the existing app. No new patterns that don't already exist.
- Reuse existing components wherever possible — never recreate what already exists.
- If a new component is needed, define its name, purpose, and full TypeScript props interface before anything else.

---

## Produce (no code yet)

Start by listing every existing file you read to inform this design.

Then output:

1. **UI description** — plain English of what the user will see and interact with
2. **Component inventory:**
   - Reused as-is: [component name] from [file path]
   - Extended/modified: [component name] — what changes and why
   - New: [ComponentName] — purpose + full TypeScript props interface
3. **Component tree** — the full parent → child hierarchy for this feature
4. **State design** — what state exists, where it lives (local / context / server), and why
5. **Data dependencies** — what API data is needed and where it enters the component tree

I will review and approve this design before any code is written.
