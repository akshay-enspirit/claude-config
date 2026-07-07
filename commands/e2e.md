---
name: e2e
description: Validate a completed spec against its acceptance criteria using end-to-end tests. Extends existing tests where possible.
---

Run E2E validation for a completed spec. Anchored to acceptance criteria from the milestone's issues. Run a few times per spec — not per issue, not per task.

Milestone name or number: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask which milestone to validate.

<HARD-GATE>
Do not claim E2E passes without running the test command and showing the actual output.
</HARD-GATE>

## Phase 1: Confirm readiness

```bash
gh milestone view "$ARGUMENTS"
gh issue list --milestone "$ARGUMENTS" --state all
```

Check that all issues in the milestone are closed. If open issues remain:
> "Milestone has N open issues: #X, #Y. E2E is most useful when a vertical slice is complete. Continue anyway, or resolve those first?"

Wait for the user's decision.

## Phase 2: Collect acceptance criteria

```bash
gh issue list --milestone "$ARGUMENTS" --state closed --json number,title,body | jq '.[]'
```

Extract every acceptance criterion from each issue's "## Acceptance Criteria" section. Build a flat list:

```
From #12 — <issue title>:
  - <criterion>
  - <criterion>
From #13 — <issue title>:
  - <criterion>
```

Also read the local spec if referenced in the issue bodies.

## Phase 3: Audit existing E2E tests

Find existing E2E and integration tests:
```bash
find . -type f \( -name "*.e2e.*" -o -name "*.spec.*" -o -path "*/e2e/*" -o -path "*/integration/*" \) \
  | grep -v node_modules | grep -v .git
```

Read the relevant ones. For each acceptance criterion, determine:
- **Already covered** — an existing test verifies this behavior end-to-end
- **Partially covered** — an existing test touches this area but doesn't fully verify the criterion
- **Not covered** — no test exercises this behavior

Report the audit before writing anything:
```
Criteria coverage:
  ✓ Already covered: "<criterion>" — <file>:<test name>
  ~ Extend needed:   "<criterion>" — <file> (partial)
  ✗ New test needed: "<criterion>"
```

Only write tests for partially covered and not covered criteria.

## Phase 4: Write or extend tests

**Extend first.** Add to an existing test file when the assertion fits naturally alongside existing tests for the same flow.

**New file only when** the criterion represents a genuinely separate flow with no natural home in existing tests.

E2E tests must:
- Exercise the system through its real public interface (HTTP, CLI, UI — whatever the actual consumer uses)
- Not mock internal collaborators
- Be named after the behavior: `it('allows user to <criterion behavior>')`

Keep tests minimal. One criterion = one focused assertion. Do not add speculative coverage.

## Phase 5: Run and show evidence

```bash
<e2e run command for this project>
```

Paste the full output. Do not summarise it.

**Pristine standard:** zero failures, zero warnings, zero errors. Fix and re-run until clean.

## Phase 6: Report

Map results back to criteria:

```
E2E results — <milestone name>

  ✓ <criterion> — <test name>
  ✓ <criterion> — <test name>
  ✗ <criterion> — FAIL: <message>

Tests: X passing, Y failing.
New: N | Extended: M | Already covered: K
```

If any criterion fails, stop and report. Do not suggest next steps — let the user decide what to do.

If all pass, report the clean evidence. The user decides whether to run `/review`, open a PR, or continue building.
