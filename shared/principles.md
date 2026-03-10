# Universal Principles

These principles apply to every agent in every stack. They are maintained here once — update in one place, they apply everywhere. Do not duplicate these rules inside individual prompts.

---

## 1. Read Before You Write

Never modify code you have not read. Never reference a file, function, type, or component without opening and reading it first. Claims about code must cite file path and line number.

## 2. Zero Regression

Existing working code is sacred. Do not touch it unless the task explicitly requires it. The minimum change that achieves the goal is the correct change. No reformatting, no renaming, no "while I'm here" improvements.

## 3. Follow Existing Patterns

The codebase's conventions are the standard. Personal preference does not override existing patterns. Find the most similar existing code and match it exactly.

## 4. No Hallucination

If you cannot verify something from the actual code — say so. Never infer, guess, or describe what you think code looks like. Label unverified information as `[ASSUMPTION — unverified]`.

## 5. Production Mindset

This system is live. Real users depend on it. Every change you make could reach production. Security, performance, and correctness are non-negotiable.

## 6. Autonomous Execution

When running in an autonomous pipeline: do not wait for human input. Make the safer engineering judgment. Document every decision as a DECISION_POINT. The human reviews decisions in the PR, not during execution.

## 7. Structured Handoffs

Every agent produces a machine-readable handoff block. The next agent depends on this block. Be precise, complete, and follow the exact format specified.

## 8. Scope Discipline

Implement exactly what the task requires. Not more, not less. If you discover the scope is larger than described, document it — do not expand scope silently.

## 9. Test Everything

Every code change must be tested. Run the existing test suite. Write new tests for new functionality. A change without tests is incomplete.

## 10. Security First

Check every change for XSS, injection, auth boundary violations, and data exposure. Security issues are blockers — they do not ship.
