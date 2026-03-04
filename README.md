# Cursor Workflow Commands

A structured, reusable prompt system for building and fixing production React + TypeScript apps with Cursor AI. Every workflow enforces a **plan-before-code discipline** that eliminates hallucination, scope creep, and silent regressions.

---

## Philosophy

**AI writes bad code when it guesses.** These prompts are designed to make guessing structurally hard:

- No code is written before requirements are fully understood
- No implementation starts before a design is reviewed and approved
- No file is touched that wasn't planned in advance
- Every claim the AI makes about your code must be backed by a file it actually read

---

## Quick Start

1. Copy the `.cursor/commands/react/` folder to your project's `.cursor/commands/` directory
2. Commands appear automatically when you type `/` in Cursor chat
3. Fill in the `User will provide {…}` placeholders with your actual content
4. Follow the workflows below based on your task type

---

## Workflows Overview

| Task Type | When to Use | Commands (in order) |
|-----------|-------------|---------------------|
| **UI Scan** | Once per project, before any UI design work | `ui-scan` |
| **Bug Fix** | Something that worked is now broken | `investigate` → `plan` → `implement` → `pr-review` → `test-checklist` |
| **Enhancement** | Small feature or UI improvement (1-5 files) | `feature-clarity` → `design-ui`* → `implement` → `pr-review` → `test-checklist` |
| **Epic/Large Feature** | Large feature touching 6+ files | `feature-clarity` → `design-ui`* → `feature-plan` → `implement` → `pr-review` → `test-checklist` |

*`design-ui` is optional but requires `ui-scan` to have been run first

---

## UI Scan — Run Once Per Project

**Location:** `react/design-ui/1-ui-scan.md`

**What it does:** Performs an exhaustive analysis of your entire UI codebase — every component, every pattern, every design token, every layout. Outputs a comprehensive `UI-DESIGN-INTELLIGENCE.md` document that serves as the design bible for all future UI work.

**When to run:**
- Once when you first set up these commands on a project
- Again if your UI codebase changes significantly (new design system, major refactor)

**Why it matters:** The `design-ui` command depends on this document. Without it, the AI cannot design UI that matches your existing patterns and will invent foreign elements.

**Output:** `UI-DESIGN-INTELLIGENCE.md` at project root (or in `docs/`)

---

## Bug Fix Workflow

Use when something that previously worked is now broken.

### Step 1: Investigate

**Command:** `react/bug-fix/1-investigate.md`

**What it does:** Traces the root cause by reading actual code. No code is written except optional `console.log` statements for gathering runtime evidence. Documents the exact file, function, and line where the bug lives, plus every candidate that was ruled out.

**Output:** A handoff block with confirmed root cause, execution path, and evidence

### Step 2: Plan

**Command:** `react/bug-fix/2-plan.md`

**What it does:** Designs the minimal surgical fix. Verifies the root cause by re-reading the code, maps every caller of the modified code, identifies regression surface, and produces a precise fix specification with test contracts.

**Output:** A handoff block with approved fix, all callers verified, and test requirements

### Step 3: Implement

**Command:** `react/bug-fix/3-implement.md`

**What it does:** Applies exactly the approved fix — nothing more. Removes all investigation logs, writes the reproduction test and regression tests, and verifies the fix in browser.

**Output:** Implementation report with confirmation statements and verification steps

### Step 4: PR Review

**Command:** `react/pr-review/pr-review.md`

**What it does:** Reviews the diff for regressions, TypeScript issues, and code quality. Reads every changed file in full, traces all consumers of modified code, and produces a verdict with blockers, warnings, and suggestions.

**When to run:** In a **fresh Cursor instance** to avoid context bias from the implementation session

**Output:** Verdict (safe to merge or needs changes) with categorized findings

### Step 5: Test Checklist

**Command:** `react/bug-fix/5-test-checklist.md`

**What it does:** Generates 10 manual browser test cases — 3 confirming the fix, 3 for adjacent flows, 3 edge cases, and 1 regression scenario.

**Output:** Ordered checklist with highest-risk items first

---

## Enhancement Workflow

Use for small features, UI changes, or functional improvements (1-5 files affected).

### Step 1: Feature Clarity

**Command:** `react/enhancement/feature-clarity.md`

**What it does:** Surfaces every ambiguity, gap, and edge case before any implementation thinking. Reads the codebase to find existing patterns, types, and data flows. Classifies the task as Enhancement (1-4 files) or Feature (5+ files, needs full planning).

**Output:** Categorized questions (must clarify vs should clarify), codebase findings, and edge case analysis

### Step 2: Design UI (Optional)

**Command:** `react/design-ui/2-design-ui.md`

**What it does:** Produces multiple distinct UI design varieties using only components and patterns from your existing codebase. Each variety includes full component tree, state design, interaction flows, and a visual prototype file.

**Prerequisites:** `ui-scan` must have been run first to generate `UI-DESIGN-INTELLIGENCE.md`

**When to use:** When the feature involves new UI that needs design decisions

**Output:** Multiple variety files you can toggle between, plus an AI recommendation

### Step 3: Implement

**Command:** `react/enhancement/implement.md`

**What it does:** Implements with production-grade rules. Learns codebase conventions first, produces a pre-flight checklist for approval, then implements following strict existing-code restraint rules and new-code quality rules.

**Output:** Implementation report with files changed, confirmation statements, and verification steps

### Step 4: PR Review

**Command:** `react/pr-review/pr-review.md`

*(Same as bug fix workflow — run in fresh Cursor instance)*

### Step 5: Test Checklist

**Command:** `react/enhancement/test-checklist.md`

**What it does:** Generates manual browser test checklist covering happy path, edge cases, and regression spot-checks for the changed files.

**Output:** Risk-ordered checklist

---

## Epic/Large Feature Workflow

Use for large features that touch many files (6+) or require multiple PRs.

### Step 1: Feature Clarity

**Command:** `react/epic/feature-clarity.md`

**What it does:** Deep requirement analysis for large features. Surfaces must-clarify vs should-clarify items, acceptance criteria gaps, data/API findings, performance considerations, and edge cases. Classifies the task size.

**Output:** Comprehensive analysis with all questions and codebase findings

### Step 2: Design UI (Optional)

**Command:** `react/design-ui/2-design-ui.md`

*(Same as enhancement workflow — requires `ui-scan` first)*

### Step 3: Feature Plan

**Command:** `react/epic/feature-plan.md`

**What it does:** Creates a complete implementation plan before any code is written. Includes impact analysis, TypeScript contract definitions, test plan, PR split strategy, implementation order, and risk mitigations. Ends with a human sign-off block.

**Output:** Approved plan document that becomes the input for implementation

### Step 4: Implement

**Command:** `react/epic/implement.md`

**What it does:** Implements one chunk of the approved plan with strict boundary enforcement. Follows chunk scope exactly — no implementing future PR work even if obvious. Establishes TypeScript contracts for future PRs to build on.

**Output:** Implementation report with extension points documented for future PRs

### Step 5: PR Review

**Command:** `react/pr-review/pr-review.md`

*(Same as other workflows — run in fresh Cursor instance)*

### Step 6: Test Checklist

**Command:** `react/epic/test-checklist.md`

**What it does:** Generates structured test checklist with 4 sections — new feature happy path, new feature edge cases, regression spot-checks, and browser console items to watch.

**Output:** Risk-ordered checklist organized by section

---

## Command Reference

| Command | Purpose | Writes Code? |
|---------|---------|--------------|
| `ui-scan` | Exhaustive UI codebase analysis | No (outputs .md) |
| `investigate` | Trace bug root cause | No (except console.log) |
| `plan` (bug) | Design minimal fix | No |
| `feature-clarity` | Surface all ambiguities | No |
| `design-ui` | Design UI varieties | Yes (prototype files) |
| `feature-plan` | Full implementation plan | No (except TypeScript types) |
| `implement` | Write production code | Yes |
| `pr-review` | Review diff for issues | No |
| `test-checklist` | Generate manual test cases | No |

---

## Key Principles Enforced

**Anti-Hallucination**
Every prompt that requires codebase knowledge tells the AI: *"Do not describe code you haven't read. List every file you opened. Label any assumption as [ASSUMPTION — unverified]."*

**Stop Conditions**
Every implementation and investigation prompt has explicit stop conditions: *"If you reach a point where you would need to assume something — stop and tell me."*

**Pre-Flight Before Code**
Every implementation prompt requires the AI to list all files it will create or modify, and wait for explicit approval before writing a single line.

**Tiered Review Verdicts**
Every review produces findings categorized as:
- 🔴 **BLOCKER** — must fix before merge
- 🟡 **WARNING** — should fix, not blocking
- 🔵 **SUGGESTION** — optional improvement

---

## Tips for Best Results

1. **Run `ui-scan` first** if you plan to use `design-ui` — it's a one-time investment that pays off for every UI feature

2. **Run `pr-review` in a fresh Cursor instance** — this avoids context bias from the implementation session

3. **Repeat commands for confidence** — run `investigate` or `feature-clarity` multiple times until you're confident in the output

4. **Fill in all placeholders** — every `User will provide {…}` needs real content for the command to work properly

5. **Follow the order** — skipping steps defeats the purpose of plan-before-code discipline

---

## Stack

These prompts are written for **React + TypeScript**. Stack-specific terms used throughout:

- Component structure: functional components, hooks, props interfaces
- Typing: no `any`, explicit interfaces, proper generics
- Separation of concerns: `utils/`, `helpers/`, no business logic in JSX
- State: local state, context, server state (React Query / SWR pattern)

---

## Directory Structure

```
.cursor/commands/react/
├── bug-fix/
│   ├── 1-investigate.md
│   ├── 2-plan.md
│   ├── 3-implement.md
│   └── 5-test-checklist.md
├── design-ui/
│   ├── 1-ui-scan.md
│   └── 2-design-ui.md
├── enhancement/
│   ├── feature-clarity.md
│   ├── implement.md
│   └── test-checklist.md
├── epic/
│   ├── feature-clarity.md
│   ├── feature-plan.md
│   ├── implement.md
│   └── test-checklist.md
└── pr-review/
    └── pr-review.md
```

---
