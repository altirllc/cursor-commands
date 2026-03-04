# STACK: React + TypeScript

---

I need to add a small feature or UI/functional improvement to a React + TypeScript production app.

---

**FEATURE REQUEST:**
User will provide {plain English description of the feature or improvement to be built}

---

## Your Task

Do not write any code. Do not suggest any implementation. Do not assume anything is clear that isn't.

This is your **one chance to ask all questions**. Do not ask in multiple rounds — surface everything now. I will respond to everything before we move to the next step.

After surfacing questions, classify this task:

Enhancement — touches 1–4 files, no shared utilities modified, no new TypeScript contracts needed → use /implement directly after clarity
Feature — touches 5+ files, modifies shared code, or requires new TypeScript contracts → requires /feature-plan before /implement

State the classification and your reasoning at the end of your output.

---

## What to Surface

**🔴 Must Clarify / 🟡 Should Clarify**
List every place where you would have to make a choice if you just started building. For each, state the ambiguity in one sentence and classify it:

- 🔴 **Must clarify** — wrong assumption causes a visible bug, broken flow, or full rework
- 🟡 **Should clarify** — wrong assumption causes a minor inconsistency or suboptimal UX

**📦 Data & API — Findings + Open Questions**
Read the codebase first — look for existing API calls, data fetching patterns, and TypeScript types relevant to this feature. For each point below, state what you found in the codebase, then flag anything that still needs my input:

- What data does this feature need and where does it come from?
- Is there an existing API call or endpoint that covers this, or does a new one need to be discussed?
- Is there an existing TypeScript type or interface to reuse, or does a new one need to be defined?

**⚛️ React + TypeScript — Findings + Open Questions**
Read the codebase first — look at how similar or nearby components manage state, share data, and handle types. For each point below, state what you found, then flag anything that still needs my input:

- Where should state live — local component, context, or server state? What does the existing pattern suggest?
- Is there a prop drilling risk given where this feature sits in the component tree?
- Are there re-render risks? What does the surrounding component structure suggest?
- Are there existing types or interfaces this feature must conform to?

**⚠️ Edge Cases Not Addressed**
Think through the full lifecycle of this feature — from the moment the user triggers it to every possible outcome. Identify every scenario the requirement has not explicitly accounted for.

If this codebase has similar features, read how they handle edge cases and apply the same thinking here. If no similar features exist, reason from the feature's own behaviour: what can go wrong, what states can it be in, what inputs or conditions could be unexpected?

Do not produce a generic checklist. Every edge case you raise must be specifically relevant to this feature.

---

## Output Format

> 📋 **Must Clarify / Should Clarify** — questions for you to answer
> 🔍 **Data & API / React + TypeScript** — AI findings from the codebase + questions where your input is still needed
> 🔎 **Edge Cases** — AI analysis for you to confirm, correct, or add to

Structure your response exactly like this:

### 🔴 Must Clarify (resolve before any work starts)

[numbered list]

### 🟡 Should Clarify (resolve before implementation)

[numbered list]

### 📦 Data & API — Findings + Open Questions

For each point: what was found in the codebase, then what still needs your input.
[numbered list — or "None" if not applicable]

### ⚛️ React + TypeScript — Findings + Open Questions

For each point: what was found in the codebase, then what still needs your input.
[numbered list — or "None" if not applicable]

### ⚠️ Edge Cases Not Addressed (confirm, correct, or add to this)

[numbered list — specific to this feature, not a generic checklist]

---

### Stop Condition

Do not proceed to any implementation thinking. Only surface findings and questions. I will respond to everything before we move to the next step.
