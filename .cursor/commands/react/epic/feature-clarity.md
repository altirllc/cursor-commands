# STACK: React + TypeScript

---

I have a React + TypeScript production app. I've been given a large feature to build.

---

**FEATURE REQUEST:**
User will provide {the full feature description}

**ACCEPTANCE CRITERIA:**
User will provide {every condition that must be true for this feature to be considered complete}

---

## Your Task

Do not write any code. Do not suggest any implementation. Do not assume anything is clear that isn't.

This is your **one chance to ask all questions**. Do not ask in multiple rounds — surface everything now. I will respond to everything before we move to the next step. Don't ask the questions which you can go over code by yourselves and find answers for them.

After surfacing questions, classify this task:

Enhancement — touches 1–4 files, no shared utilities modified, no new TypeScript contracts needed → use /implement directly after clarity
Feature — touches 5+ files, modifies shared code, or requires new TypeScript contracts → requires /feature-plan before /implement

State the classification and your reasoning at the end of your output.

---

## What to Surface

**🔴 Must Clarify / 🟡 Should Clarify**
List every assumption buried in this requirement that you would have to make if you just started building. This includes: requirements ambiguities, user role and permission questions, feature flag and rollback decisions, and anything else where a wrong assumption causes real damage. For each:

- State the assumption or ambiguity in one sentence
- Classify it:
  - 🔴 **Must clarify** — wrong assumption causes a bug, breaking change, or full rework
  - 🟡 **Should clarify** — wrong assumption causes a minor inconsistency
- State what breaks if the assumption is wrong

**📋 Acceptance Criteria Gaps**
Read every acceptance criterion carefully. Flag any that are:

- Contradictory — two criteria that cannot both be true
- Unmeasurable — no way to objectively verify it is met
- Incomplete — a scenario is implied but not fully specified
- Missing — a scenario that clearly needs an AC but has none

**📦 Data & API — Findings + Open Questions**
Read the codebase first — look for existing API calls, data fetching patterns, and TypeScript types relevant to this feature. For each point below, state what you found, then flag what still needs my input:

- What data does this feature need and where does it come from?
- Are the required API endpoints already built and documented, currently in progress, or do they need to be built?
- Is the full API response shape known? Are there existing TypeScript types to reuse or extend?

**⚡ Performance & Scale — Findings + Open Questions**
Read the codebase first — look for existing patterns like pagination, virtualisation, lazy loading, or caching. Then assess this feature:

- Does this feature involve large datasets, long lists, or data-heavy operations?
- What does the existing codebase pattern suggest for handling scale here?
- Flag anything that needs a decision before implementation starts.

**⚛️ React + TypeScript — Findings + Open Questions**
Read the codebase first — look at how similar or nearby components manage state, share data, and handle types. For each point below, state what you found, then flag what still needs my input:

- Where should state live — local component, context, or server state? What does the existing pattern suggest?
- Is there a prop drilling risk given the scale of this feature?
- Are there re-render risks? What does the surrounding component structure suggest?
- Are there existing types or interfaces this feature must conform to or extend?
- Are there any shared state conflicts with existing features?

**⚠️ Edge Cases Not Addressed**
Think through the full lifecycle of this feature — every user action, every system response, every failure mode. Identify every scenario the requirement has not explicitly accounted for.

If this codebase has similar features, read how they handle edge cases and apply the same thinking here. If no similar features exist, reason from the feature's own behaviour: what can go wrong, what states can it be in, what inputs or conditions could be unexpected?

Do not produce a generic checklist. Every edge case you raise must be specifically relevant to this feature.

---

## Output Format

> 🔴🟡 **Must Clarify / Should Clarify** — questions for you to answer
> 📋 **AC Gaps** — AI analysis of your acceptance criteria, confirm or correct
> 📦⚡⚛️ **Data & API / Performance / React + TypeScript** — AI findings from the codebase + questions where your input is still needed
> ⚠️ **Edge Cases** — AI analysis for you to confirm, correct, or add to

Structure your response exactly like this:

### 🔴 Must Clarify (resolve before any work starts)

[numbered list — one sentence per item, state what breaks if wrong]

### 🟡 Should Clarify (resolve before implementation)

[numbered list — one sentence per item]

### 📋 Acceptance Criteria Gaps

[numbered list — or "None found" if all AC is clear and complete]

### 📦 Data & API — Findings + Open Questions

For each point: what was found in the codebase, then what still needs your input.
[numbered list — or "None" if not applicable]

### ⚡ Performance & Scale — Findings + Open Questions

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
