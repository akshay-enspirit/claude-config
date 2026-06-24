---
name: debug
description: Use when encountering any bug, test failure, or unexpected behavior
---

Find the root cause before proposing any fix. Do not guess or pattern-match symptoms.

## Phase 1: Understand (required before any fix)
1. Reproduce the issue reliably. If you can't, say so and stop.
2. Read the full error message and stack trace.
3. State your hypothesis for the root cause in one sentence.
4. Find the exact line of code causing the issue — not just the symptom.

## Phase 2: Verify
- Confirm the hypothesis by tracing execution.
- Check other callsites or related code that may be affected by the same root cause.

## Phase 3: Fix
- Fix the root cause only. No surrounding cleanup in the same change.
- Verify the fix addresses the reproduction case.
- State what changed and why.

If you cannot find the root cause after Phase 1, say so explicitly. Do not propose speculative fixes.
