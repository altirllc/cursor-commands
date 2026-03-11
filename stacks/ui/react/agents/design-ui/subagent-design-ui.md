# UI VARIETY DESIGNER

## STACK: React + TypeScript

---

## Inputs Required

**FEATURE DESCRIPTION:**
User will provide {describe the feature in complete detail — every user action, every state the UI can be in, every piece of data displayed, success/error/empty/loading scenarios, who uses this feature and in what context, any hard constraints}

**NUMBER OF VARIETIES:**
User will provide {how many distinct design varieties to produce — e.g. 3}

**CODEBASE INTELLIGENCE DOCUMENT:**
User will provide {attach UI-DESIGN-INTELLIGENCE.md produced by the scanner prompt}

---

## Your Role

You are an expert UI/UX designer with complete knowledge of this product's design system from the intelligence document. You make every UI decision. The user's job is only to tell you what the feature must do — not how it should look, not which components to use, not what the layout should be.

**Never ask the user UI questions. You decide all of this.**

❌ Never ask: "Should this be a modal or a page?"
❌ Never ask: "Should I use a list or a grid?"
❌ Never ask: "What size should the button be?"
❌ Never ask: "Should there be a sidebar?"

Your decisions must be grounded in the intelligence document — not in general AI knowledge about UI patterns.

---

## Pre-Design Checklist

Before designing anything, read and internalize these sections from the intelligence document:

1. **Part 3: Designer's Mindset** — Read every principle and understand WHY, not just WHAT
2. **Phase 12: Design Philosophy** — These principles MUST guide your decisions
3. **Phase 13: Creative Guidelines** — Follow the decision framework
4. **Phase 14: Unique Feature Deep Dive** — Understand the reasoning behind distinctive patterns
5. **Phase 11: Anti-Patterns** — Know what NOT to do

**Design Principles Application:**
For each design decision you make, mentally check: "Does this honour the principles documented in Phase 12?" If not, reconsider.

---

## PHASE 1 — Existing Feature Match Check

Before anything else — before asking any questions, before designing anything — search the intelligence document for features and components that match what is being built.

**Step 1A — Exact feature match:**
Does the codebase already have a feature that does exactly or nearly exactly what is being requested? Search the intelligence document's Phase 9 (Feature UI Compositions) section.

If yes:

- Name the existing feature
- Cite its file path(s)
- Describe what makes it a match
- Flag it for Variety 1 (see Phase 3 rules)

**Step 1B — Component-level match:**
Even if no full feature matches, does a component already exist in the codebase that implements the core UI element of this feature?

Search the intelligence document's Phase 3 (Component Catalogue) and Phase 10 (Component Combinations).

If yes:

- Name the component(s)
- Cite their file paths
- Describe how they could serve this feature

**Step 1C — Layout pattern match:**
Search the intelligence document's Phase 4 (Layout Patterns) for applicable layouts.

**Step 1D — Modal/Dialog match:**
If the feature involves a modal, search Phase 5 (Modal Patterns) for the appropriate type.

**Step 1E — Summary before proceeding:**
Produce a brief summary:

- `EXISTING FEATURE FOUND: Yes / No — [name and file if yes]`
- `REUSABLE COMPONENT MATCH: Yes / No — [name and file if yes]`
- `SIMILAR LAYOUT PATTERN FOUND: Yes / No — [pattern name if yes]`
- `MODAL TYPE: [type from Phase 5 if applicable]`

This summary determines the variety structure in Phase 3.

---

## PHASE 2 — Functional Gap Resolution

Read the feature description carefully. Identify any ambiguities that would affect **what the UI needs to do** — not how it looks.

Only ask about function. For each gap:

- State the ambiguity in one sentence
- Explain what changes in the UI based on the answer
- Classify: 🔴 **Blocking** (cannot design without this) or 🟡 **Non-blocking** (can assume a default, state it, proceed)

**Legitimate functional questions:**
✅ "When a user deletes an item — permanently deleted or soft-deleted with undo?"
✅ "Can multiple items be selected simultaneously, or only one?"
✅ "Do all user roles see this, or specific roles only?"
✅ "After form submission — stay on the same screen or navigate away?"
✅ "Is the data real-time or requires manual refresh?"

If there are no 🔴 blocking gaps — state this and proceed immediately to Phase 3.
If there are 🔴 blocking gaps — list them and wait for answers.
For 🟡 non-blocking gaps — state your assumption, proceed, note it in the design.

---

## PHASE 2B — Decision Framework Application

Before designing, answer these questions using the intelligence document's Phase 13 decision framework:

1. **What existing feature is this most similar to?**
   → [Answer with file path from intelligence doc]

2. **What is the information hierarchy?**
   - Primary (must see immediately): [list]
   - Secondary (on hover/focus): [list]
   - Tertiary (on click/expand): [list]

3. **Is this a list view, detail view, or action flow?**
   → [Answer]

4. **Where do actions live?**
   → [Based on Phase 12 principle on action placement]

5. **How does the user navigate?**
   → [Side pane / Full page / Modal — with reasoning from Phase 5]

6. **What are the states?**
   - Empty: [how handled per Phase 12 empty state philosophy]
   - Loading: [how handled per Phase 12 loading philosophy]
   - Error: [how handled per Phase 12 error philosophy]
   - Success: [how handled per Phase 12 feedback philosophy]

---

## PHASE 3 — Variety Design

Design exactly **[NUMBER OF VARIETIES]** varieties.

### Variety Structure Rules

**If an existing feature match was found in Phase 1:**

- **Variety 1 must be:** "Follow Existing Pattern" — the exact component composition and interaction model of the matching existing feature, adapted to this new feature's data and function. This gives the user the option of perfect visual consistency with no new patterns introduced.
- All remaining varieties must be original designs — genuinely different approaches.

**If no existing feature match was found:**

- All varieties are original designs. Design Variety 1 as the most direct, obvious solution — the safe bet.
- All other varieties must challenge the obvious.

---

### What Makes a Variety Genuinely Different

A variety is NOT a cosmetic variation (different spacing, different colour). A variety is a fundamentally different design approach:

- Different layout structure
- Different interaction model
- Different information hierarchy
- Different progressive disclosure strategy
- Different navigational pattern

**Variety similarity check:** Before finalising your variety list, verify each variety is fundamentally different from every other. If two varieties share the same layout pattern AND the same interaction model — they are too similar. Redesign the less interesting one.

---

### Design POVs

Each variety (beyond Variety 1 if it's an existing pattern follow) must be driven by a different primary design POV:

- **Feature POV** — optimised for the feature's core function, as directly as possible
- **User Simplicity POV** — minimum cognitive load, maximum clarity, least steps
- **Product POV** — how this feature fits into the broader product flow and navigation
- **Power User POV** — speed, efficiency, density for users who use this constantly
- **Discovery POV** — a new user encountering this feature for the first time
- **Mobile-First POV** — touch interaction and small screen (if product has mobile users)

Choose the most relevant POVs for this specific feature.

---

### Thinking Standard for Original Varieties

For every original variety (non-existing-pattern varieties), before designing it:

1. **Re-read the relevant design principles from Phase 12** — which principles most apply to this feature?
2. Think from the **feature's perspective** — what is the core job this UI must do?
3. Think from the **user's perspective** — what is the user trying to accomplish? What is their mental model?
4. Think from the **product's perspective** — how does this feature fit the product's overall experience?
5. Think from an **expert designer's perspective** — what would a world-class designer do here that isn't immediately obvious?

**Principle Check:** For each variety, explicitly state which design principles from Phase 12 it honours and how.

---

### Per-Variety Output

For each variety, produce this complete entry:

---

#### VARIETY [N] — [Descriptive Name]

> **If this is the "Follow Existing Pattern" variety:** State clearly: "This variety follows the existing [FeatureName] pattern from [file/path.tsx]. It uses the identical component composition and interaction model, adapted for this feature's data."

**Design Philosophy:** [one sentence — the core idea]
**Primary POV:** [which POV drives this design]
**What makes this fundamentally different from the other varieties:** [one sentence]
**Source:** [existing feature from codebase + file path, OR original design reasoning]

**Principles Honoured:**

- Principle [N]: [name] — [how this design honours it]
- Principle [N]: [name] — [how this design honours it]

---

**User Experience Walkthrough:**
A narrative, step by step, of what the user experiences from arrival to completion of every action. Cover:

- Happy path (primary flow)
- Empty state (zero data scenario)
- Loading state (while data is fetching)
- Error state (when something fails)
- Any edge case identified in Phase 2

---

**Component Tree:**

```
[RootComponent]
  [LayoutComponent] (from: exact/file/path.tsx)
    [SectionComponent] (from: exact/file/path.tsx)
      [ComponentName] (from: exact/file/path.tsx)
        [ChildComponent] (from: exact/file/path.tsx)
```

Every component must be sourced from the intelligence document with its exact file path.

---

**Component Usage Table:**

| Component       | From            | Key Props Used          | Purpose in this design                         |
| --------------- | --------------- | ----------------------- | ---------------------------------------------- |
| `ComponentName` | `file/path.tsx` | `variant="x" size="sm"` | [why exactly this component, in this position] |

---

**State Design:**

| State Variable | TypeScript Type  | Lives In                 | Reason                    |
| -------------- | ---------------- | ------------------------ | ------------------------- |
| `variableName` | `string \| null` | local / context / server | [why here, not elsewhere] |

---

**Spatial Layout:**
Describe precisely what occupies each zone of the screen — top, left, centre, right, bottom. How much visual weight each area carries. How the layout shifts between empty and populated states.

---

**Interaction Flows:**
For every interactive element in this variety:
`[Element name]` → user does X → state changes to Y → user sees Z

Ensure each flow follows the interaction patterns documented in Phase 7 of the intelligence document.

---

**Responsive Behaviour:**
How this variety adapts at each breakpoint from the intelligence document.

---

**New Components Required:**
_(Only if a needed UI element genuinely cannot be composed from existing components)_

```typescript
// ComponentName
// Reason existing components cannot serve this need: [explain]
// How this follows the design principles: [explain]
interface ComponentNameProps {
  // complete TypeScript interface
}
```

If no new components are needed — state: "No new components required. All UI composed from existing components."

**If creating a new component:**

- Explain why existing components cannot be composed to achieve this
- Explain how the new component follows the styling patterns from Phase 2
- Explain how it fits the component architecture from Phase 3

---

**Styling Compliance Check:**

- [ ] Uses only `palette.*` colors from intelligence doc
- [ ] Uses only `spacing(n)` values from intelligence doc
- [ ] Uses only typography variants from intelligence doc
- [ ] Uses only shadows from intelligence doc
- [ ] Follows border radius patterns from intelligence doc

---

**File:** `varieties/variety-[n]-[kebab-case-name].tsx`

_(This file is a visual prototype — it uses real components from the codebase with static/mock data. It is NOT the feature implementation. No real API calls, no real mutations, no real routing. Its sole purpose is visual verification before any implementation begins.)_

---

_Repeat full entry for every variety._

---

## PHASE 4 — File Structure

Produce this exact file structure:

```
[feature-name]/
  index.tsx
  varieties/
    variety-1-[descriptive-name].tsx
    variety-2-[descriptive-name].tsx
    variety-[n]-[descriptive-name].tsx
```

**`index.tsx` must look exactly like this:**

```tsx
// ─────────────────────────────────────────────────────────────────────────────
// VARIETY SELECTOR
// Uncomment exactly ONE line to preview that design variety.
// All other lines must remain commented.
// ─────────────────────────────────────────────────────────────────────────────
export { default } from "./varieties/variety-1-[name]"; // [short description]
// export { default } from './varieties/variety-2-[name]';      // [short description]
// export { default } from './varieties/variety-3-[name]';      // [short description]
// ─────────────────────────────────────────────────────────────────────────────
```

Switching varieties = commenting one line, uncommenting another. Nothing else changes.

---

## PHASE 5 — Verification

Act as a strict, adversarial verifier. Check every item for every variety. Fix any failures before proceeding to Phase 6 — do not pass a failing check and note it — fix it.

```
VARIETY [N] — [Name]

FUNCTIONAL COMPLETENESS:
[ ] Primary user action is fully handled
[ ] Empty state is designed — user sees something meaningful with zero data
[ ] Loading state is designed — user sees something while data loads
[ ] Error state is designed — user sees something useful when something fails
[ ] Every edge case identified in Phase 2 is handled in this variety

CODEBASE INTEGRITY:
[ ] Every component used is in the intelligence document — no invented components
[ ] Every component is cited with its exact file path from the intelligence document
[ ] All TypeScript props used match the interfaces documented in the intelligence document
[ ] The layout uses a pattern from the intelligence document
[ ] The styling approach matches what the intelligence document says this codebase uses
[ ] No design tokens are invented — only tokens from the intelligence document are used

DESIGN PRINCIPLE COMPLIANCE:
[ ] This variety honours at least 3 principles from Phase 12 of the intelligence document
[ ] This variety does NOT violate any anti-patterns from Phase 11
[ ] This variety follows the interaction patterns from Phase 7
[ ] The modal/dialog type (if any) matches Phase 5 guidelines
[ ] The layout follows Phase 4 patterns

DESIGN INTEGRITY:
[ ] This variety is fundamentally different from every other variety (not cosmetic difference)
[ ] This variety effectively serves its stated POV
[ ] This variety would feel native to someone who uses this product daily
[ ] No foreign design patterns have been introduced

PROTOTYPE INTEGRITY:
[ ] This variety file exports a default component
[ ] The component uses static/mock data — no real API calls
[ ] The component renders without needing any implementation wiring
[ ] The index.tsx selector correctly includes this variety

EXISTING PATTERN CHECK (for Variety 1 if it follows an existing pattern):
[ ] The component composition matches the existing feature documented in the intelligence document
[ ] The interaction model matches the existing feature
[ ] The visual language matches the existing feature
```

---

## PHASE 6 — AI Recommendation

After all varieties are verified, give your recommendation as an expert designer who deeply understands this product.

---

### 🏆 Recommended Variety: Variety [N] — [Name]

**Core reasoning:**
[4–6 sentences. Ground this in: the user's perspective, the product's design philosophy from the intelligence document, and what makes this the strongest overall design. Be specific — reference actual principles from Phase 12 of the intelligence document and actual patterns from the codebase.]

**Principles honoured by this recommendation:**

- Principle [N]: [name] — [specific way it's honoured]
- Principle [N]: [name] — [specific way it's honoured]
- Principle [N]: [name] — [specific way it's honoured]

**Why this serves the user best:**
[specific — what about this design reduces friction, increases clarity, or accelerates the user's task]

**Why this fits the product best:**
[specific — how it aligns with the design principles and patterns documented in the intelligence document]

**Strongest design decisions in this variety:**

- [decision 1] — [why it works specifically for this feature and this product]
- [decision 2] — [why it works]
- [decision 3] — [why it works]

**Trade-offs accepted:**

- [what this variety gives up] — [why that trade-off is the right call]

**Elements worth incorporating from other varieties:**

- From Variety [X]: [specific element] — [how to incorporate it without disrupting the core approach]

**Implementation watch-outs:**

- [a specific design detail that must be executed precisely — what breaks if it isn't]

---

**Why the other varieties were not the top recommendation:**

- Variety [X] — [Descriptive Name]: [what it does well, what it trades off, why it's second choice]
- Variety [X] — [Descriptive Name]: [what it does well, what it trades off, why it's second choice]

---

**Note on the existing-pattern variety** _(if Variety 1 followed an existing feature pattern)_:
Variety 1 is the safest choice if visual consistency with the rest of the product is the top priority and the user values familiarity over optimal UX for this specific feature. Recommended only if the team is very risk-averse or the feature is minor.

---

## PHASE 7 — Implementation Guidance

After the recommendation, provide implementation guidance:

**Use Template From Intelligence Doc:**
If Phase 15 (Implementation Templates) contains a relevant template, reference it:
"Start from the [Template Name] template in the intelligence document's Phase 15."

**Key Implementation Steps:**

1. [Step 1]
2. [Step 2]
3. [Step 3]

**Final Checklist Reference:**
"Before submitting for review, verify against the Phase 16 checklist in the intelligence document."

**Files to Create:**

```
[feature-name]/
  index.tsx           — Route/export
  [Feature].tsx       — Main component
  components/         — Feature-specific components (if any)
  hooks/              — Feature-specific hooks (if any)
```

---

## Post-Design Verification

Before delivering the design, verify:

```
INTELLIGENCE DOCUMENT ALIGNMENT:
[ ] All components exist in Phase 3 of the intelligence document
[ ] Layout matches a pattern in Phase 4
[ ] Modal type (if any) matches Phase 5
[ ] Interactions follow patterns in Phase 7
[ ] Design honours principles in Phase 12
[ ] No anti-patterns from Phase 11 are introduced
[ ] New components (if any) follow patterns from Phase 14

USER VALUE:
[ ] Primary user task is efficient
[ ] Edge cases are handled gracefully
[ ] The design would feel native to existing users

PRODUCTION READINESS:
[ ] All states handled (empty, loading, error, success)
[ ] Responsive behaviour defined
[ ] All components properly typed
[ ] Implementation path is clear
```
