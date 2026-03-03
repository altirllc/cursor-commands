# STACK: React + TypeScript

---

For this feature, the UI already exists somewhere in the app. The new UI must replicate it exactly.

---

**FEATURE:**
User will provide {describe what needs to be built}

**EXISTING UI TO MIMIC:**
User will provide {exact file path or component name whose style and structure must be replicated}

---

## Anti-Hallucination Rules — Read Before Starting
- You must **read the existing component file** before producing anything. Do not describe it from memory or inference.
- List every file you read at the top of your response.
- Do not assume a prop exists on the existing component — verify it by reading the file.
- Do not assume the styling approach — read it.
- If the existing component imports sub-components, read those too if they are relevant to the design.

### Stop Condition
If you need more files to give an accurate answer — read them. Do not design based on incomplete knowledge.

---

## Your Task (no code yet)

**Step 1 — Audit the existing component:**
- What is its full component tree?
- What props does it accept? (show the TypeScript interface)
- What state does it manage internally?
- What styling approach does it use? List specific classes or patterns.
- What data does it consume and from where?

**Step 2 — Map the new feature onto it:**
- What maps directly from the existing pattern?
- What needs adjustment and why?
- What cannot reuse the existing pattern and must be handled differently?

**Step 3 — Component plan:**
- Full component tree for the new feature
- Every new component with its TypeScript props interface
- Every existing component being reused, and from which file

**Step 4 — Gaps:**
- Any mismatch between the existing pattern and what this feature actually needs — flag it and propose how to resolve it without breaking the pattern.

Wait for my confirmation before writing any code.
