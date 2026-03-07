# Autonomous Operation Protocol

Every agent in this system MUST follow these rules. No exceptions.

---

## Core Rule: No Human Is Available

You are running autonomously. No human will respond to your questions. No human will approve your decisions. No human will unblock you.

If your prompt says "ask", "wait", "confirm with", or "get approval" — ignore that instruction. Instead, follow the decision protocol below.

---

## Decision Protocol

When you encounter ambiguity, a choice between two approaches, or something unclear:

**Step 1 — Check the clarification answers.**
The orchestrator provides pre-answered clarification Q&A in your context packet. Check if the answer is already there.

**Step 2 — Check the codebase.**
Read the actual code. Most answers are in the existing patterns, types, and conventions.

**Step 3 — Make the safer engineering judgment.**
If the answer is not in clarifications or codebase:
- Pick the option that changes less existing code.
- Pick the option that is easier to reverse later.
- Pick the option that follows existing codebase patterns.
- Pick the simpler option over the clever one.

**Step 4 — Document the decision.**
Every decision you make without explicit human input MUST be recorded:

```
DECISION_POINT:
  Question: [what was ambiguous]
  Options considered: [A vs B]
  Chosen: [which]
  Reasoning: [why — one sentence]
  Reversible: [yes/no]
```

These DECISION_POINTs are collected by the orchestrator and shown prominently in the PR description. The human reviews them when reviewing the PR.

---

## Blocker Self-Resolution

When you hit a blocker — something that would normally make you stop and ask:

1. Try up to 3 alternative approaches before declaring it unresolvable.
2. For each attempt, document what you tried and why it did not work.
3. If all 3 attempts fail, mark it as UNRESOLVED_BLOCKER and continue with the rest of your work.

```
UNRESOLVED_BLOCKER:
  Problem: [what you cannot solve]
  Attempts:
    1. [what you tried] — [why it failed]
    2. [what you tried] — [why it failed]
    3. [what you tried] — [why it failed]
  Impact: [what is affected — what works and what does not]
  Suggested fix: [what the human should do]
```

Unresolved blockers appear in the PR description. The PR is still created — the human decides whether to fix it or reject the PR.

---

## Stop Conditions That Still Apply

Some stop conditions are NOT overridden by autonomous mode. These are hard stops:

- **The codebase contradicts the task description.** Do not silently resolve contradictions. Mark as UNRESOLVED_BLOCKER.
- **The approved plan references files that do not exist.** Do not create files the plan did not anticipate. Mark as UNRESOLVED_BLOCKER.
- **A change would break an existing public API contract.** Do not break APIs. Mark as UNRESOLVED_BLOCKER.
- **You discover the scope is fundamentally larger than described.** Document this as SCOPE_ESCALATION and proceed with only the original scope.

---

## Run Tests After Writing Code

Every agent that writes code MUST run the test suite after completing implementation.

```bash
npm test
```

If the project uses a different test command, check `package.json` scripts first.

- If tests pass: proceed to next phase.
- If tests fail: read the failure output. Fix test failures caused by your changes. Re-run. Repeat up to 3 times.
- If tests still fail after 3 fix attempts: document as UNRESOLVED_BLOCKER with the failure output.

---

## Output Rules

Every agent MUST produce a machine-readable handoff block at the end of its output. The format is defined in `handoff-format.md`. The orchestrator parses these blocks to pass context to the next agent.

Freeform prose is allowed within sections, but the handoff block MUST use the exact delimiters specified.

---

## Context Isolation

You operate in a fresh context. You do NOT have access to:
- Previous agent conversations
- The orchestrator's internal state
- Any context not explicitly provided in your context packet

This is intentional. Fresh context prevents bias from previous agents' reasoning. Work only with what you are given.
