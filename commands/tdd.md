---
name: tdd
description: Execute a planned issue task by task using red-green-refactor. Pauses after each task for review before continuing.
---

Execute the implementation plan for an issue one task at a time. After each task, show evidence and pause for review before moving on.

Issue number: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask which issue to work on.

<HARD-GATE>
No production code before a failing test. If code exists before the test is written, delete it and start over.
</HARD-GATE>

<HARD-GATE>
No completion claim without running the verification command and showing the actual output in this message.
</HARD-GATE>

## Phase 1: Load the plan

```bash
gh issue view $ARGUMENTS --comments
```

Find the comment starting with `## Implementation Plan`. Extract:
- Goal
- Spec path (read the local file if it exists)
- All tasks in order

If no plan comment exists, stop:
> "No plan found on issue #$ARGUMENTS. Run `/plan $ARGUMENTS` first."

List the tasks and ask: "Which task to start from? (default: Task 1)"

## Phase 2: Execute tasks

Work through tasks in order. For each task, run the full red-green-refactor cycle.

---

### RED — Write the failing test

Write only the test code from the plan. Do not write any implementation yet.

Run the test:
```bash
<exact command from plan>
```

**Verify the failure is correct:**
- The test must FAIL — if it passes, something is wrong with the test or the behavior already exists. Stop and investigate.
- The failure must be a missing-implementation failure, not a syntax error, import error, or compilation failure. Fix environmental issues first.
- Paste the actual output before proceeding.

If the test passes immediately:
> "Test passed before any implementation was written. This means the behavior already exists or the test is not testing what it should. Stopping."

---

### GREEN — Write minimal implementation

Write only enough code to make this specific test pass. No extra cases, no speculative options, no convenience methods not required by the test.

Run the test:
```bash
<exact command from plan>
```

**Verify green:**
- The test must PASS
- All previously passing tests must still PASS (run the full suite if there are other tests)
- Output must be pristine: zero failures, zero warnings, zero errors

Paste the actual output.

If the output is not pristine (warnings, deprecation notices, console noise), fix it before continuing.

---

### REFACTOR — Clean up while green

Look for:
- Duplicated logic that can be extracted
- Names that don't reflect what the code does
- Complexity that can be hidden behind a simpler interface

After any change, re-run the test and confirm it stays green. Paste output.

If nothing needs refactoring, say so explicitly — do not skip this step silently.

---

### Commit

```bash
git add <files changed>
git commit -m "<type>(<scope>): <description from plan>"
```

---

### Pause and report

Post a status comment on the issue:

```bash
gh issue comment $ARGUMENTS --body "$(cat <<'EOF'
**Task N complete:** <behavior>

Test output:
\`\`\`
<paste actual test output>
\`\`\`
EOF
)"
```

Then stop and report to the user:

> **Task N done.** `<behavior>`
> Tests: X passing, 0 warnings.
> Ready for Task N+1: `<next task name>`. Continue?

Wait for explicit approval before starting the next task.

---

## Evidence standard

Before reporting any task as complete, you must be able to answer yes to all of these:

- [ ] I ran the test command and it failed before implementation (RED confirmed)
- [ ] I ran the test command and it passed after implementation (GREEN confirmed)
- [ ] I pasted the actual command output, not a description of it
- [ ] All other tests still pass
- [ ] Output is pristine — no warnings, no errors, no noise

If any box is unchecked, the task is not complete.

## What to do when stuck

| Problem | Action |
|---|---|
| Test is hard to write | The interface is too complex. Simplify it first. |
| Must mock everything | Code is too coupled. Use dependency injection. |
| Test passes before implementation | Behavior already exists, or test is wrong. Investigate both. |
| Implementation makes unrelated tests fail | You changed more than the test required. Revert and try again minimally. |
| Output has warnings | Fix the warnings. Do not ship noisy output. |

If genuinely blocked after investigating, stop and describe exactly what you tried and what happened. Do not guess.
