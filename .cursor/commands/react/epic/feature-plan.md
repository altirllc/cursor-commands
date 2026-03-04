# STACK: React + TypeScript

---

## What Is This Step

This is the planning step. It sits between requirement clarity and implementation. Nothing gets built here. No code is written.

The output of this step is a single approved plan document — precise enough that the AI can execute it in agent mode without ambiguity. Every decision that could slow down or derail implementation gets made here, with you, before a single line is written.

**How plan mode and this prompt work together:**
When you run `/feature-plan` in plan mode, the AI cannot write or execute code — it can only read and reason. The phases below give that reading and reasoning a precise structure. The AI's job is to actively explore the codebase — reading files, tracing imports, following dependencies — and use each phase as a frame for what it finds. The phases are not a checklist to fill from memory. They are an investigation structure.

At the end of its exploration, the AI outputs the analysis across all phases plus an empty sign-off block. You review the analysis, fill in the sign-off block, and that completed document becomes the `APPROVED PLAN` passed to `/implement` in agent mode.

---

## Inputs

**TASK:**
User will provide {paste the full feature description + all clarified requirements + all answered questions from previous step}

**APPROVED UI DESIGN** _(optional — include if UI design step was completed before planning)_:
User will provide {paste the approved component plan from the UI design step — component tree, state design, TypeScript interfaces, data dependencies. If UI design has not been done yet, leave this blank — the planning step can proceed without it and the UI design can follow.}

---

## Codebase Access — Confirm Before Starting

Before doing anything else, confirm your codebase access:

- If you have full codebase access (via `@codebase`, attached files, or MCP): state this explicitly, then proceed.
- If you do NOT have full codebase access: stop immediately and say so. Do not proceed. Do not infer, guess, or fill sections with plausible-sounding findings. Codebase access is required for this step to produce a reliable plan.

Every section in this prompt that says "read the codebase" means exactly that — open and read the actual file. Not reasoning from memory. Not inferring from the file name. If you cannot open a file, say so rather than describing what you think it contains.

---

## Anti-Hallucination Rules

- Do not list any file as needing changes without reading it first.
- Do not describe any existing pattern without reading the file it lives in.
- Do not define any TypeScript interface that extends an existing type without reading that existing type first.
- Do not propose a PR split without reading all affected files first.
- Every claim must be backed by a file you read in this session. If you haven't read it — read it before stating anything about it.
- If a section asks for "findings from the codebase" and you cannot find relevant files — say "not found" rather than describing what you'd expect to find.
- At the end of your output, list every file you actually opened and read during this investigation. This is a verifiable record. If a file is not on that list, do not make claims about it.

---

## Stop Conditions

- If investigating scope reveals this feature is significantly larger or riskier than described — stop and flag it before continuing. Do not produce a plan for a scope that hasn't been agreed.
- If a decision is needed that you cannot make without user input — surface it immediately. Do not assume and proceed.
- If you find a conflict between the task description and what actually exists in the codebase — stop and report it. Do not resolve it silently.
- If any phase produces findings that would materially change the scope of a previous phase — go back and update that phase before continuing.

---

## Do Not Write Any Implementation Code

One exception: TypeScript interface and type definitions. These are design contracts, not implementation — writing them precisely now prevents costly disagreements later. You may write complete TypeScript interfaces and type aliases in Phase 2 only. Every other output is planning, analysis, and decisions only.

---

## Phase 1 — Impact Analysis

Read every file relevant to this feature before answering this phase. Do not infer from file names — open and read them.

**Files to create (new):**

| File path          | Purpose        | Risk                        |
| ------------------ | -------------- | --------------------------- |
| `path/to/file.tsx` | [what it does] | 🟢 New — no regression risk |

**Files to modify (existing):**

| File path          | What changes           | Regression risk              |
| ------------------ | ---------------------- | ---------------------------- |
| `path/to/file.tsx` | [exactly what changes] | 🔴 High / 🟡 Medium / 🟢 Low |

Risk classification:

- 🔴 High — shared utility, hook, or component used across the app
- 🟡 Medium — used in multiple places but scoped to a feature area
- 🟢 Low — isolated to this feature only

**Adjacent files at risk:**
Files that won't be modified but could be affected by changes nearby. State exactly why each is at risk and what could break.

**Highest regression risk:**
Which existing user flow is most likely to break? Why? What file and line is the danger point?

**Scope size assessment:**
Based on files touched and changes required, classify this feature:

- 🟢 Small — 1–4 files, well-isolated, low coordination overhead
- 🟡 Medium — 5–10 files, some shared code touched, needs careful ordering
- 🔴 Large — 10+ files, shared utilities modified, or multiple parallel concerns

If 🔴: explicitly flag before continuing. A large scope may need to be broken into separate feature requests before planning proceeds.

---

## Phase 2 — TypeScript Contract Plan

This is the most important planning phase for a large feature. The interfaces you define here become the contracts every future PR builds on. Define them precisely now — changes after implementation starts are expensive.

Read every relevant existing type file before answering. Do not extend a type you haven't read.

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
For every type change — is there any modification that would compile cleanly but silently alter runtime behaviour? (e.g. a new optional field that consuming components don't check for in their render logic, causing empty renders rather than compile errors.) Call each one out explicitly.

---

## Phase 3 — Test Plan

For each acceptance criterion and each significant edge case in this feature, define the test that will verify it.

This section does not write test code. It defines what must be tested so the implementation step has a clear testing contract.

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
List any test files adjacent to modified code. These must be checked for regressions after implementation.

**Test coverage gaps in existing code:**
If the files being modified have low or no test coverage, flag this now. Implementing on top of untested code increases regression risk. State what the gap is and whether it should be addressed in this PR or tracked separately.

---

## Phase 4 — PR Strategy

Based on your impact analysis:

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
CHUNK BOUNDARY RISK: [what breaks if the implementation of this chunk bleeds into the next chunk's scope — what the implementer must watch for]
```

**Guidance:** If this touches more than 5–6 files, splitting is strongly advised. The final decision is yours.

**Feature flag:**
Should this feature be released behind a feature flag?

- If yes: flag name, where it lives, what it guards, what the off-state looks like
- If no: reasoning

**Rollback plan:**
If this reaches production and breaks something, what is the fastest rollback path? Be specific — not "revert the PR" but exactly which files, which change, and whether a revert is safe given the PR's database or API changes.

---

## Phase 5 — Implementation Order

For each chunk (or single PR if not split), propose the implementation order at the file level.

The order must reflect the actual dependency chain — types before consumers, hooks before components, utilities before the code that calls them.

```
CHUNK [N]: [Name]

Step 1: [file path] — [what gets built, why this comes first]
Step 2: [file path] — [what gets built, why this follows step 1]
Step 3: [file path] — [what gets built]
Step N: Tests — [which test files get written, covering which scenarios from Phase 3]

Dependency chain: [explain why this order is safe — what each step unlocks for the next]
What breaks if order is violated: [what would happen if step 3 was attempted before step 1]
```

---

## Phase 6 — Existing Patterns to Follow

Read the codebase before answering. Do not describe a pattern without citing the exact file it lives in.

For each pattern this feature must follow:

```
PATTERN: [name]
FOUND IN: [exact file path]
WHAT TO FOLLOW: [specifically what to replicate — component structure, hook pattern, state approach, error handling, etc.]
WHY: [what breaks or diverges if not followed]
```

If no clear pattern exists for part of this feature, say so explicitly. Do not invent a pattern and present it as existing.

---

## Phase 7 — Risks and Mitigations

List every significant risk identified across all phases above. No arbitrary cap — list every real one.

For each:

```
RISK: [describe clearly]
LIKELIHOOD: High / Medium / Low
IMPACT IF IT OCCURS: [what breaks — be specific about user impact]
MITIGATION: [specific action that prevents or limits this]
DETECTION: [how you would know this happened in production — what to monitor or alert on]
RECOVERY: [if it does happen, what is the fastest fix path]
```

---

## Phase 8 — Decisions Required Before Implementation

Every implementation decision that could go either way — where a wrong call mid-implementation causes rework or regression. Surface everything here. The implementer cannot ask questions mid-agent-run — these must be resolved before the session starts.

For each:

```
DECISION: [state the decision clearly in one sentence]
OPTION A: [description + tradeoff]
OPTION B: [description + tradeoff]
RECOMMENDATION: [which option and why — or "no recommendation, needs your input"]
CONSEQUENCE IF WRONG: [what rework looks like — specifically which files and how much]
```

---

## Files Read — Record

List every file you actually opened and read during this investigation. Be exact — this list is checked against your claims. Any claim about a file not on this list is a hallucination.

```
FILES READ:
- [exact file path]
- [exact file path]
```

---

## ⚠️ Human Sign-Off Required

Fill in the block below and return it. The AI will not generate the implement blocks until this is received.

Only three things are required from you here: your answers to the open decisions, any changes you want to the proposed plan, and a go signal. Everything else the AI already has from the phases above.

```
═══════════════════════════════════════════════════════════════
SIGN-OFF — [feature name]
═══════════════════════════════════════════════════════════════

── YOUR DECISIONS ──────────────────────────────────────────────
[Answer each open decision from Phase 8. The implementer follows
these exactly and does not re-decide them mid-session.]

- [Decision from Phase 8]: → [your answer]
- [Decision from Phase 8]: → [your answer]

── CHANGES TO THE PLAN ─────────────────────────────────────────
Any interfaces, files, PR split, implementation order, test scope,
feature flag, or patterns you want changed from what was proposed:

[or write "none — proceed as proposed"]

── PROCEED ─────────────────────────────────────────────────────
[ ] Yes — generate implement blocks

═══════════════════════════════════════════════════════════════
```

---

## Auto-Generated Implement Inputs

**After the human fills in and returns the sign-off block above, produce the following — one block per chunk. Do not produce these until the sign-off block is returned and complete.**

For each chunk defined in the approved plan, output a fully self-contained block formatted exactly as shown below. The human should be able to copy one block and paste it directly into `/implement` with zero editing or assembly.

Do not summarise, abbreviate, or reference "see above." Every block must be fully standalone — the implementer has no access to this planning session.

---

```
╔══════════════════════════════════════════════════════════════════╗
║  /implement — CHUNK [N] of [TOTAL]: [Chunk Name]                ║
║  Feature: [feature name]          Date: [date]                  ║
╚══════════════════════════════════════════════════════════════════╝

━━━ TASK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Full feature description. Every clarified requirement. Every answered
question from the clarity step. Written completely — no references to
"see previous step." The implementer has no other context.]

━━━ APPROVED PLAN ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[The complete planning output from all phases above, plus the human's
sign-off with their decisions and any changes to the plan. Written as
a complete summary — not "see above." The implementer has no access
to this planning session.]

━━━ THIS CHUNK COVERS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IN SCOPE — implement exactly this and nothing else:
[Copy the full step list for this chunk from Phase 5, including the
test step. File paths, what gets built, why the order is what it is.]

OUT OF SCOPE — do not touch, even if obvious or easy:
[List every file and concern explicitly deferred to other chunks.
If the implementer finds themselves writing code that belongs here —
stop and report, do not implement.]

CHUNK BOUNDARY — what must be true when this chunk ends:
[From the Chunk Handoff Instructions in the sign-off block — exact
conditions the next chunk depends on. E.g. "UserProfile interface
must be fully defined and exported before Chunk 2 starts."]

━━━ TYPESCRIPT CONTRACTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Every interface and type this chunk creates or modifies, copied
exactly from Phase 2. Include CONSUMED BY and EXTENSIBILITY for each.
The implementer must not deviate from these definitions without
stopping and reporting.]

━━━ TEST CONTRACTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Every test scenario from Phase 3 that applies to this chunk.
Full TEST / TYPE / COVERS / SCENARIO / EXPECTED / MOCKS NEEDED
for each. Tests are not optional — they are part of this chunk's
definition of done.]

━━━ DECISIONS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Every decision from Phase 8 with the human's answer filled in.
The implementer follows these exactly and does not re-decide them.]

- [Decision]: → [Human's answer]
- [Decision]: → [Human's answer]

━━━ PATTERNS TO FOLLOW ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Every pattern from Phase 6 relevant to this chunk.
PATTERN / FOUND IN / WHAT TO FOLLOW / WHY for each.]

━━━ KNOWN DEVIATIONS FROM STANDARD PATTERNS ━━━━━━━━━━━━━━━━━━━━━

[From the sign-off block. Anything intentionally non-standard so the
implementer doesn't "fix" it. Or "None."]

━━━ RISKS RELEVANT TO THIS CHUNK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Risks from Phase 7 that apply to this specific chunk only.
RISK / MITIGATION / DETECTION for each.]

━━━ SESSION HANDOFF (to be filled in by implementer at end) ━━━━━━

The implementer must fill this in at the end of the session and
provide it to the next chunk's session before that session starts.

CHUNK [N] COMPLETED: [ ] Yes  [ ] Partial — [what was not completed]

FILES CREATED:
- [path] — [one sentence purpose]

FILES MODIFIED:
- [path] — [exactly what changed]

DEVIATIONS FROM PLAN:
[Any place the implementation differed from the approved plan,
and why. "None" if followed exactly.]

DECISIONS MADE THAT WERE NOT IN THE PLAN:
[Any judgement call made mid-implementation that was not pre-decided.
These must be reviewed before the next chunk starts.]

EXTENSION POINTS FOR NEXT CHUNK:
[Where Chunk N+1 should hook in, and how. File paths and what to look for.]

ISSUES SPOTTED BUT NOT FIXED:
[Anything noticed that is out of this chunk's scope.]

CHUNK BOUNDARY VERIFIED:
[Confirm the boundary conditions listed above are met.
e.g. "UserProfile interface is exported from src/types/user.ts — confirmed."]
```

---

Produce one complete block per chunk. Label each block clearly. The human copies the relevant block and pastes it into `/implement` — nothing else required.
