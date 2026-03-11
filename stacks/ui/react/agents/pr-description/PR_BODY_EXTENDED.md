## What

All route-related flows now show a single success message — "Request sent to Samsara. Route will update if successful." — for assign, update, and unassign operations. This includes the Assign Route modal, CancelOrderModal, OrderActionsModal, and BulkOrderStatusModal. The old messages "Route assigned successfully" and "Route updated successfully" have been removed.

## Why

Users need consistent feedback that their route change request was sent to Samsara. The actual route update is asynchronous and depends on Samsara; a unified message sets the right expectation and avoids implying immediate completion.

## How

- Updated `assignRoute.success` and `updateRoute.success` in `toastMessages.ts` to the unified copy.
- Simplified `useAssignRoutes.ts` `onSuccess`: always calls `showSuccessToast('order', 'assignRoute')` regardless of whether the operation was assign, update, or unassign. Removed `hasNewAssignments` / `hasUpdates` branching logic.
- Extended to all route flows: `useUnassignOrderRoutesWithSideEffects` (CancelOrderModal, OrderActionsModal) and `useBulkUnassignOrderRoutesWithSideEffects` (BulkOrderStatusModal) use `updateRoute`, which now shows the same message.

## Changes

| File | Change | Risk |
|------|--------|------|
| `packages/core/utils/toastMessages.ts` | assignRoute.success and updateRoute.success = "Request sent to Samsara. Route will update if successful." | Low |
| `apps/logixflow/src/features/AssignRoute/useAssignRoutes.ts` | onSuccess always calls showSuccessToast('order', 'assignRoute'); removed hasNewAssignments/hasUpdates | Low |

## Decisions Made by Agent

> **REVIEW THESE** — The agent made these decisions autonomously. Verify each one is acceptable.

| # | Decision | Chosen | Reasoning | Reversible |
|---|----------|--------|-----------|------------|
| 1 | Scope of unified toast | All route flows | Client/product requested unified message for assign/update/unassign; extended to CancelOrderModal, OrderActionsModal, BulkOrderStatusModal per user feedback | Yes |
| 2 | Toast action key | Reuse assignRoute and updateRoute | Both actions now share the same success message; no new ToastAction needed | Yes |

## Unresolved Blockers

None. All blockers were resolved.

## Review Findings

Clean review. No blockers, warnings, or suggestions.

## Review Loop Summary

- Iterations: 1 of 5
- Test failures fixed: 0
- Review blockers fixed: 0
- Final test result: PASS
- Final review verdict: SAFE_TO_MERGE (low regression risk)

## Test Results

**Automated tests:** PASS (pnpm test, pnpm check:typescript)
**New tests written:** 0

## Manual Test Checklist

> Complete these before merging.

**Expected toast for all route flows:** "Request sent to Samsara. Route will update if successful."

### Happy Path — Assign Route Modal

- [ ] Assign Leg 1 (single order) — Orders list or Order Details → Assign Route → select one order with no routes → assign Leg 1 only → Submit → Toast: "Request sent to Samsara. Route will update if successful."
- [ ] Update Leg 1 (single order) — Assign Route → order with Leg 1 already assigned → change Leg 1 to different route → Submit → Toast: same
- [ ] Unassign Leg 2 (single order) — Assign Route → order with Leg 1+Leg 2 → clear Leg 2 only → Submit → Toast: same
- [ ] Bulk assign — Orders list → select 2+ orders → Assign Route → assign Leg 1 for all → Submit → Toast: same

### Happy Path — Other Unassign Flows

- [ ] CancelOrderModal unassign — Order in ROUTED or IN_TRANSIT with routes → Update Status → Mark as Cancelled → Submit → Toast: "Request sent to Samsara. Route will update if successful."
- [ ] OrderActionsModal unassign — Order in ROUTED → Update Status → action that requires route unassignment (e.g. Mark as Cancelled, Mark as Planning) → Submit → Toast: same
- [ ] BulkOrderStatusModal unassign — Select multiple ROUTED orders → Bulk Update Status → action requiring route unassignment → Submit → Toast: same

### Edge Cases

- [ ] Single order — assign both Leg 1 and Leg 2 → Submit → Toast: same
- [ ] Multiple orders — mixed assign/update/unassign → Submit → Toast: same (single toast)

### Browser Console

- [ ] No new console errors during Assign Route happy path
- [ ] No new console warnings
- [ ] No unexpected network requests

## Risk Assessment

**Overall risk:** Low

**Reasoning:** Change is limited to toast copy. No API or routing changes. All route flows now use the same message. Automated tests pass.

**Highest risk area:** `packages/core/utils/toastMessages.ts` — manual verification of all route flows recommended.

**Rollback plan:** Revert both files; previous behavior restored immediately.

---

*This PR was created autonomously by the multi-agent pipeline. Review the "Decisions Made by Agent" and "Unresolved Blockers" sections carefully.*
