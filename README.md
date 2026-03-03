# Cursor Workflow

A structured, reusable prompt system for building and fixing production apps with Cursor AI. Every workflow enforces a plan-before-code discipline that eliminates hallucination, scope creep, and silent regressions.

---

## Philosophy

**AI writes bad code when it guesses.** These prompts are designed to make guessing structurally hard:

- No code is written before requirements are fully understood
- No implementation starts before a design is reviewed and approved
- No file is touched that wasn't planned in advance
- Every claim the AI makes about your code must be backed by a file it actually read

---

## How to Use

1. Create a .cursor/commands directory in your project root
2. Add relevant commands .md files from this repo to your repo commands directory.
3. When you need a specific command, commands will automatically appear in the chat when you type /. Check the command. Identify what it needs as input. Fill in every `User will provide {…}` placeholder with your actual content and put it inside cursor chat along with command.
4. Follow the commands in order.

---

## Workflows

### 🐛 Bug Fix — `bug-fix/`

Use when something that worked is now broken.

| Step | File                  | What Happens                                                      |
| ---- | --------------------- | ----------------------------------------------------------------- |
| 1    | `1-investigate.md`    | AI reads the codebase and traces the root cause. No code written. |
| 2    | `2-design-fix.md`     | AI designs the minimal surgical fix. No code written.             |
| 3    | `3-implement-fix.md`  | AI implements exactly the approved fix. Nothing more.             |
| 4    | `4-review-pr.md`      | AI reviews the diff critically before merge.                      |
| 5    | `5-test-checklist.md` | AI generates a manual browser test checklist.                     |

---

### ✨ Small Improvement — `small-improvement/`

Use for small features, UI changes, or functional improvements (1–5 files affected).

| Step | File                   | What Happens                                                                  |
| ---- | ---------------------- | ----------------------------------------------------------------------------- |
| 1    | `1-feature-clarity.md` | AI surfaces every ambiguity. You answer all questions.                        |
| 2A   | `2A-design-ui.md`      | AI designs the UI from existing codebase patterns.                            |
| 2B   | `2B-mimic-design.md`   | _(Alternative to 2A)_ AI designs the UI by replicating an existing component. |
| 3    | `3-implement.md`       | AI implements with production-grade rules.                                    |
| 4    | `4-review-pr.md`       | AI reviews the diff critically before merge.                                  |
| 5    | `5-test-checklist.md`  | AI generates a manual browser test checklist.                                 |

Use **2A** when there's no obvious existing UI to copy. Use **2B** when you know exactly which existing component the new UI should look like.

---

### 🏗️ Big Feature — `big-feature/`

Use for large features that touch many files or require multiple PRs (6+ files affected).

| Step | File                   | What Happens                                                                                     |
| ---- | ---------------------- | ------------------------------------------------------------------------------------------------ |
| 1    | `1-feature-clarity.md` | AI surfaces every ambiguity and hidden assumption.                                               |
| 2    | `2-feature-plan.md`    | AI analyses risk, proposes PR split, and implementation order. **You make the final decisions.** |
| 3A   | `3A-design-ui.md`      | AI designs the full UI from existing codebase patterns.                                          |
| 3B   | `3B-mimic-ui.md`       | _(Alternative to 3A)_ AI designs by replicating an existing pattern.                             |
| 4    | `4-implement.md`       | AI implements with a mandatory pre-flight confirmation before touching code.                     |
| 5    | `5-review-pr.md`       | AI reviews the diff with full architecture and regression scrutiny.                              |
| 6    | `6-test-checklist.md`  | AI generates a structured test checklist with 4 sections.                                        |

> **Important:** Step 2 ends with a **Human Decision Required** section. You must write down your decisions on PR strategy, implementation order, and ambiguity answers before proceeding to Step 3.

---

## Key Principles Enforced in Every Prompt

**Anti-Hallucination**
Every prompt that requires codebase knowledge tells the AI: _"Do not describe code you haven't read. List every file you opened. Label any assumption as [ASSUMPTION — unverified]."_

**Stop Conditions**
Every implementation and investigation prompt has an explicit stop condition: _"If you reach a point where you would need to assume something — stop and tell me."_

**Pre-Flight Before Code**
Every implementation prompt requires the AI to list all files it will create or modify, and wait for your explicit go-ahead before writing a single line.

**Tiered Review Verdicts**
Every review prompt produces findings categorised as:

- 🔴 **BLOCKER** — must fix before merge
- 🟡 **WARNING** — should fix, not blocking
- 🔵 **SUGGESTION** — optional improvement

---

## Stack

These prompts are written for **React + TypeScript**. Stack-specific terms used throughout:

- Component structure: functional components, hooks, props interfaces
- Typing: no `any`, explicit interfaces, proper generics
- Separation of concerns: `utils/`, `helpers/`, no business logic in JSX
- State: local state, context, server state (React Query / SWR pattern)

Support for other stacks (Next.js App Router, Vue 3, etc.) coming later.

---
