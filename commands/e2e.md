---
name: e2e
description: Validate a completed milestone against acceptance criteria by running end-to-end tests.
---

Validate a completed milestone against acceptance criteria using end-to-end tests.

Milestone to validate: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask which milestone to validate.

<HARD-GATE>
Do not claim E2E passes without running the test command and showing the actual output.
</HARD-GATE>

## Phase 1: Readiness check

```bash
gh milestone view $ARGUMENTS
gh issue list --milestone $ARGUMENTS --state open
```

If any issues are still open, stop:

> "Milestone #$ARGUMENTS has open issues. Close or move them before running E2E validation."

## Phase 2: Collect acceptance criteria

```bash
gh issue list --milestone $ARGUMENTS --state closed --limit 100
```

For each closed issue, fetch its acceptance criteria:

```bash
gh issue view <number>
```

Compile all acceptance criteria into a list, grouped by issue number and title.

## Phase 3: Audit test coverage

Scan the codebase for existing E2E and integration tests:

```bash
find . -type f -name "*.test.*" -o -name "*.spec.*" -o -name "*.e2e.*" | grep -v node_modules
```

For each acceptance criterion, categorise it as:
- **Covered** — an existing test exercises this criterion
- **Partial** — a test exists but doesn't fully cover the criterion
- **Missing** — no test covers this criterion

## Phase 4: Implement missing tests

For each missing or partial criterion:
- Extend the existing test file if the criterion fits a flow already being tested
- Create a new test file only for a genuinely distinct flow

Tests must:
- Exercise the real public interface (HTTP, WebSocket, CLI)
- Not mock internal components — only mock external services (third-party APIs, email, etc.)
- Assert the observable outcome stated in the acceptance criterion

## Phase 5: Run and capture output

Run the full E2E test suite:

```bash
<test command for this project>
```

Paste the complete output. It must show:
- Zero failures
- Zero warnings
- Zero errors

If anything fails, fix it before proceeding.

## Phase 6: Report results

Map test outcomes back to the original criteria:

```
## E2E Validation: <Milestone Name>

| # | Criterion | Test | Status |
|---|-----------|------|--------|
| #12 | <criterion> | <test file:line> | PASS |
| #13 | <criterion> | <test file:line> | PASS |

X criteria, X tests, 0 failures.
```
