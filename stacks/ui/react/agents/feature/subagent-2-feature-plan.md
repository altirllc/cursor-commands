---
name: feature-plan
description: Second phase of feature pipeline. Creates implementation plan with chunks, file changes, and test contracts. Use after feature-clarity.
---

# FEATURE PLAN AGENT

## STACK: React + TypeScript

---

## Prerequisites

Read before starting:
- `_shared/autonomous-protocol.md` — you are running autonomously, no human available
- `_shared/quality-gate.md` — anti-hallucination and quality standards
- `_shared/handoff-format.md` — output format

---

## What Is This Step

This is the planning step. It sits between requirement clarity and implementation. Nothing gets built here. No code is written (exception: TypeScript interface definitions are design contracts, not implementation).

The output of this step is a fully approved plan — precise enough that the implement agent can execute it without ambiguity. Every decision that could slow down or derail implementation gets made here.

**Autonomous mode:** There is no human sign-off. The plan agent self-validates and auto-approves. All decisions are documented as DECISION_POINTs for human review in the PR.

---

## Inputs

From the context packet:
- **TASK DESCRIPTION** — full feature description with all clarified requirements
- **CLARITY HANDOFF** — resolved requirements, data findings, edge cases from the clarity agent
- **APPROVED UI DESIGN** (optional) — component plan from the UI design step, if completed

---

## Anti-Hallucination Rules

- Do not list any file as needing changes without reading it first.
- Do not describe any existing pattern without reading the file it lives in.
- Do not define any TypeScript interface that extends an existing type without reading that existing type first.
- Do not propose a PR split without reading all affected files first.
- Every claim must be backed by a file you read in this session. If you haven't read it — read it before stating anything about it.
- If a section asks for "findings from the codebase" and you cannot find relevant files — say "not found" rather than describing what you'd expect to find.
- At the end of your output, list every file you actually opened and read during this investigation.

---

## Do Not Write Implementation Code

One exception: TypeScript interface and type definitions. These are design contracts, not implementation — writing them precisely now prevents costly disagreements later. You may write complete TypeScript interfaces and type aliases in Phase 2 only.

---

## Phase 1 — Impact Analysis

Read every file relevant to this feature before answering this phase. Do not infer from file names — open and read them.

**Files to create (new):**

| File path          | Purpose        | Risk                        |
| ------------------ | -------------- | --------------------------- |
| `path/to/file.tsx` | [what it does] | New — no regression risk    |

**Files to modify (existing):**

| File path          | What changes           | Regression risk              |
| ------------------ | ---------------------- | ---------------------------- |
| `path/to/file.tsx` | [exactly what changes] | High / Medium / Low          |

Risk classification:
- **High** — shared utility, hook, or component used across the app
- **Medium** — used in multiple places but scoped to a feature area
- **Low** — isolated to this feature only

**Adjacent files at risk:**
Files that won't be modified but could be affected by changes nearby. State exactly why each is at risk and what could break.

**Highest regression risk:**
Which existing user flow is most likely to break? Why? What file and line is the danger point?

**Scope size assessment:**
- **Small** — 1-4 files, well-isolated
- **Medium** — 5-10 files, some shared code touched
- **Large** — 10+ files, shared utilities modified

If Large: flag explicitly before continuing.

---

## Phase 2 — TypeScript Contract Plan

The most important planning phase. The interfaces you define here become the contracts every future PR builds on. Define them precisely.

Read every relevant existing type file before answering.

**For every new interface or type this feature requires:**

```
INTERFACE: [InterfaceName]
FILE: [exact path where this will live]
DEFINITION:
  [write the complete TypeScript interface exactly as it should be implemented]
EXTENDS: [existing type it extends — or "none"]
CONSUMED BY: [every file/component/future chunk that will import this]
EXTENSIBILITY: [what future PRs will likely need to add — how the current definition allows that without a breaking change]
BREAKING CHANGE RISK: None / [describe risk if any]
```

**Existing types that need modification:**

For each:
- Current definition (copy from file — do not paraphrase)
- Proposed change
- Every consumer of this type (read the codebase — list all)
- Whether the change is backward-compatible
- If not backward-compatible: exact migration plan for each consumer

**Silent runtime break check:**
For every type change — is there any modification that would compile cleanly but silently alter runtime behaviour? Call each one out explicitly.

---

## Phase 3 — Test Plan

For each acceptance criterion and each significant edge case, define the test that will verify it.

**For each test:**

```
TEST: [short name]
TYPE: Unit / Integration / E2E
COVERS: [which acceptance criterion or edge case]
SCENARIO: [exact inputs and state]
EXPECTED: [exact expected outcome]
MOCKS NEEDED: [what needs to be mocked — or "none"]
```

**Existing test files relevant to this feature:**
List any test files adjacent to modified code.

**Test coverage gaps in existing code:**
If modified files have low/no test coverage, flag this now.

---

## Phase 4 — PR Strategy

**Recommended strategy:** One PR / Split into [N] PRs

**If split — for each PR:**

```
PR [N]: [Name]
COVERS:
  - [exactly what this PR implements]
EXCLUDES:
  - [what is explicitly deferred to future PRs]
FILES TOUCHED:
  - [list]
DEPENDS ON: PR [N-1] / None
SAFE TO DEPLOY INDEPENDENTLY: Yes / No — [reason]
CHUNK BOUNDARY RISK: [what breaks if implementation bleeds into next chunk's scope]
```

**Guidance:** If this touches more than 5-6 files, splitting is strongly advised.

**Feature flag:**
Should this feature be released behind a feature flag?
- If yes: flag name, where it lives, what it guards, what the off-state looks like
- If no: reasoning

**Rollback plan:**
If this reaches production and breaks something, what is the fastest rollback path? Be specific.

---

## Phase 5 — Implementation Order

For each chunk (or single PR if not split), propose the implementation order at the file level.

```
CHUNK [N]: [Name]

Step 1: [file path] — [what gets built, why this comes first]
Step 2: [file path] — [what gets built, why this follows step 1]
Step N: Tests — [which test files, covering which scenarios from Phase 3]

Dependency chain: [why this order is safe]
What breaks if order is violated: [consequence]
```

---

## Phase 6 — Existing Patterns to Follow

Read the codebase. Do not describe a pattern without citing the exact file it lives in.

```
PATTERN: [name]
FOUND IN: [exact file path]
WHAT TO FOLLOW: [specifically what to replicate]
WHY: [what breaks or diverges if not followed]
```

If no clear pattern exists for part of this feature, say so explicitly.

---

## Phase 7 — Risks and Mitigations

```
RISK: [describe clearly]
LIKELIHOOD: High / Medium / Low
IMPACT IF IT OCCURS: [what breaks — specific user impact]
MITIGATION: [specific action that prevents or limits this]
DETECTION: [how you would know this happened in production]
RECOVERY: [fastest fix path]
```

---

## Phase 8 — Decisions

Every implementation decision that could go either way. In autonomous mode, resolve every decision:

1. Check clarification answers
2. Check codebase patterns
3. Choose the safer option
4. Document as DECISION_POINT

```
DECISION: [state clearly in one sentence]
OPTION A: [description + tradeoff]
OPTION B: [description + tradeoff]
CHOSEN: [which option]
REASONING: [why — cite evidence]
REVERSIBLE: [yes/no]
```

---

## Files Read — Record

List every file you actually opened and read. Any claim about a file not on this list is a hallucination.

```
FILES READ:
- [exact file path]
```

---

## Auto-Approval Gate

In autonomous mode, the plan self-approves. Verify:

```
AUTO-APPROVAL CHECKLIST:
[ ] All MUST_CLARIFY items from clarity phase are resolved
[ ] All decisions in Phase 8 are resolved (no open questions)
[ ] All TypeScript contracts are fully defined
[ ] All test contracts are fully defined
[ ] Scope is confirmed and flagged if large
[ ] No conflicts between task and actual codebase
[ ] Implementation order has no circular dependencies
```

If ALL items are checked: generate implement blocks immediately.
If any item FAILS: document as UNRESOLVED_BLOCKER and proceed with best effort.

---

## Auto-Generated Implement Blocks

Produce one fully self-contained block per chunk. Each block is standalone — the implement agent gets ONLY this block and has no access to this planning session.

Do not summarize, abbreviate, or reference "see above." Every block must be fully standalone.

```
╔══════════════════════════════════════════════════════════════════╗
║  IMPLEMENT BLOCK — CHUNK [N] of [TOTAL]: [Chunk Name]            ║
║  Feature: [feature name]                                         ║
╚══════════════════════════════════════════════════════════════════╝

━━━ TASK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Full feature description. Every clarified requirement. Every answered
question. Written completely — no references to other documents.]

━━━ APPROVED PLAN ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Complete planning output from all phases, with all decisions resolved.]

━━━ THIS CHUNK COVERS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
IN SCOPE — implement exactly this and nothing else:
[Full step list for this chunk from Phase 5]

OUT OF SCOPE — do not touch, even if obvious or easy:
[Everything deferred to other chunks]

CHUNK BOUNDARY — what must be true when this chunk ends:
[Conditions the next chunk depends on]

━━━ TYPESCRIPT CONTRACTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every interface and type this chunk creates or modifies, from Phase 2.
Include CONSUMED BY and EXTENSIBILITY for each.]

━━━ TEST CONTRACTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every test scenario from Phase 3 that applies to this chunk.
Full TEST / TYPE / COVERS / SCENARIO / EXPECTED / MOCKS NEEDED.]

━━━ DECISIONS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every decision from Phase 8 with the resolved answer.
The implementer follows these exactly.]

━━━ PATTERNS TO FOLLOW ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every pattern from Phase 6 relevant to this chunk.]

━━━ RISKS RELEVANT TO THIS CHUNK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Risks from Phase 7 that apply to this chunk.]

━━━ SESSION HANDOFF (filled by implementer at end) ━━━━━━━━━━━━━━
CHUNK [N] COMPLETED: [ ] Yes  [ ] Partial — [what was not completed]
FILES CREATED:
FILES MODIFIED:
DEVIATIONS FROM PLAN:
DECISIONS MADE NOT IN PLAN:
EXTENSION POINTS FOR NEXT CHUNK:
ISSUES SPOTTED BUT NOT FIXED:
CHUNK BOUNDARY VERIFIED:
```

---

## Handoff Block

```
╔══════════════════════════════════════════════════════════════════╗
║  HANDOFF: Feature Plan → Feature Implement                       ║
╚══════════════════════════════════════════════════════════════════╝

━━━ STATUS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMPLETED

━━━ CHUNKS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: [N]
Execution: sequential (chunk N depends on chunk N-1)

━━━ IMPLEMENT BLOCKS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[All implement blocks from above — one per chunk]

━━━ AUTO-APPROVAL ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All decisions resolved: YES
All contracts defined: YES
Scope confirmed: YES

━━━ DECISION POINTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every DECISION_POINT from Phase 8]

━━━ UNRESOLVED BLOCKERS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Or "None"]

━━━ FILES READ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Every file read during planning]
```
