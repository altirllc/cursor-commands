# STACK: React + TypeScript

---

I have a React + TypeScript production app. A large feature needs to be built.

---

**TASK:**
User will provide {paste the full feature description + all clarified requirements from Step 1}

---

## Anti-Hallucination Rules — Read Before Starting

- Do not list files that "probably need to be changed" based on their name. Read them first.
- Do not describe existing architecture unless you have read the relevant files in this session.
- At the top of your response, list every file you actually read.
- If you cannot find how a specific flow works without reading more files — read them. Do not infer.

### Stop Conditions

- If answering any section below would require you to assume something about a file you haven't read — read it first.
- If during your investigation you discover the scope is significantly larger or riskier than the feature description suggests — **stop and flag it immediately** before continuing. Do not silently absorb it and proceed.

---

## Do Not Write Any Code

Work through every section below in order.

---

### 📁 Files Read

Before answering anything else, list every file you read during this investigation.

---

### 🎯 Impact Analysis

Read every relevant file before answering.

**Files to modify:**
For each file, state why it needs to change and classify its regression risk:

- 🔴 High — shared utility, hook, or component used across the app
- 🟡 Medium — used in multiple places but scoped to a feature area
- 🟢 Low — isolated to this feature only

**Adjacent files at risk:**
Files that won't be modified but could break due to changes nearby. State exactly why each is at risk.

**Highest regression risk:**
Which existing user flow is most likely to break, and why?

---

### 🔷 TypeScript Impact

Read the relevant type files before answering.

- Which shared interfaces or types will need to change?
- What other files import those types? List every consumer.
- Could any type change silently break a consumer without a compile error? (e.g. optional fields being added that callers don't handle)

---

### 🔀 PR Strategy

Based on your impact analysis, propose a PR strategy:

- Should this be one PR or split into multiple?
- If split: name each PR and state exactly what it covers and why that boundary makes sense.
- Guidance: if this touches more than 5–6 files, splitting is strongly advised. The final decision is the developer's.

Also answer: should this feature be released behind a feature flag? What would a rollback look like if something breaks in production?

---

### 📋 Implementation Order

Propose the safest order to build this — chunk by chunk. For each chunk, state why it comes before the next one.

---

### 🧩 Existing Patterns to Follow

Read the codebase before answering. For each pattern relevant to this feature:

- Name the pattern
- Cite the exact file path where it lives
- State why this feature should follow it

---

### 🔥 Risks & Mitigations

List every significant risk you identified during your investigation. For each:

- Describe the risk clearly
- State the mitigation

Do not cap this at an arbitrary number. List every real risk.

---

### ❓ Decisions Needed Before Implementation

List every implementation choice that could go either way — where a wrong decision mid-implementation would cause rework or a regression. These must be decided before Step 3 starts.

For each: state the available options and the tradeoff between them.

---

## ⚠️ Human Decision Required

Read the AI output above, then fill in every field below before proceeding to Step 3.

```
FILES READ BY AI: [confirm you've reviewed the list — add any files you think were missed]

PR STRATEGY: [One PR / Split into N PRs — name each if split]

IMPLEMENTATION ORDER: [chunk 1, chunk 2, ...]

FEATURE FLAG: [Yes — flag name: X / No — reasoning]

TYPESCRIPT RISK SIGN-OFF: [Reviewed — no breaking changes / Reviewed — breaking changes identified, discussed and acceptable / Needs further discussion before proceeding]

AMBIGUITY DECISIONS:
  - [Decision from ❓ section]: [Your answer]
  - [Decision from ❓ section]: [Your answer]
```

Do not proceed to Step 3 until every field is filled in.
