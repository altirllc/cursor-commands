# Quality Gate — Universal Standards

Every agent follows these standards. No exceptions.

---

## Anti-Hallucination Rules

1. Do not reference any file, function, type, hook, or component without reading it first.
2. Do not describe how code works without reading the actual file — not from memory, not from file names.
3. Every claim about the codebase must cite a specific file path and line number.
4. If you are working from an assumption, label it: `[ASSUMPTION — unverified]`.
5. If you cannot find something — say "not found." Do not describe what you think it would look like.
6. At the end of your output, list every file you read. Any claim about a file not on that list is invalid.

---

## Production Mindset

This system is live. Real users depend on it.

**Priority hierarchy:**
1. Zero regression on existing code — highest priority, above everything
2. Follow existing codebase conventions — consistency over personal preference
3. Staff-engineer quality for new code — especially TypeScript contracts and component boundaries
4. Structure for the future, implement only the present — no over-engineering

---

## Zero Regression Principle

- Do not modify existing logic unless the task explicitly requires it.
- If you must touch existing code — make the minimum change required.
- No reformatting of existing code. No renaming. No TypeScript improvements to code you did not write for this task.
- No "while I'm here" changes. Spotted issues go in the handoff block under ISSUES SPOTTED.
- Every modified shared utility, hook, or type: find and read every consumer before changing it.

---

## Code Quality Standards (New Code)

**TypeScript:**
- No `any`. No `as X` assertions to escape real type problems.
- Every type is precise — not overly broad, not overly narrow.
- Reuse existing types. Do not duplicate.

**React:**
- Components handle presentation only. No data fetching or business logic in JSX.
- Every new component handles: loading state, empty state, error state — unless explicitly excluded by the task.
- Hook dependency arrays must be complete and correct.
- Side effects must have proper cleanup.

**Structure:**
- Follow exact file and folder conventions from the codebase.
- New files go where similar files go.
- Component structure matches the most similar existing component.

**No loose ends:**
- No `console.log` (except investigation logs during bug-fix, which are tracked and removed).
- No commented-out code.
- No placeholder values.
- No unused imports or variables.
- No TODO comments — document extension points in the handoff block.

---

## Security Standards

Every agent that writes code must check for:

1. **XSS** — user input rendered in JSX must be sanitized. No `dangerouslySetInnerHTML` without explicit justification.
2. **Injection** — no string concatenation in queries, API calls, or dynamic code execution.
3. **Auth boundaries** — new routes and API calls must respect existing auth patterns.
4. **Sensitive data** — no secrets, tokens, or PII in code, logs, or comments.
5. **Dependencies** — no new dependencies without checking for known vulnerabilities.

If a security concern is found, it is classified as a BLOCKER in PR review. It does not ship.

---

## Performance Standards

Every agent that writes code must check for:

1. **Unnecessary re-renders** — memoize where it matters (large lists, expensive computations).
2. **Missing cleanup** — subscriptions, timers, event listeners must clean up on unmount.
3. **Bundle size** — no large library imports when a small utility exists.
4. **Network** — no redundant API calls. Use existing caching patterns.
5. **Large lists** — use virtualization if the codebase has it. Flag if missing.

Performance issues are classified as WARNINGS in PR review unless they cause visible user impact, in which case they are BLOCKERS.
