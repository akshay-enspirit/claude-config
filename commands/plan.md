---
name: plan
description: Break a GitHub issue into a detailed TDD implementation plan posted as an issue comment.
---

Turn an approved issue into a step-by-step TDD plan. The plan is posted as a comment on the issue so any session can pick it up.

Issue number to plan: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user which issue to plan.

<HARD-GATE>
Do NOT post the plan comment until the user has approved it.
</HARD-GATE>

## Phase 1: Read the issue

```bash
gh issue view $ARGUMENTS --comments
```

Extract:
- What to build
- Acceptance criteria
- Blocked by (confirm blockers are closed before continuing)
- Spec path (e.g. `.claude/specs/YYYY-MM-DD-<topic>.md`)

If a local spec file is referenced and exists, read it for full context.

If any acceptance criterion is ambiguous, list the open questions and ask the user before writing tasks. Do not guess.

Check for an existing plan comment. If one exists, ask: "A plan already exists on this issue. Update it or create a new one?"

## Phase 2: Explore relevant code

Read the files listed in the spec's "Key Files" section. For each:
- Understand the current shape of the module
- Note the existing patterns (naming, error handling, test structure)
- Identify the seam at which the new behavior will attach

Do not explore broadly — stay focused on what the plan needs.

## Phase 3: Prefactor check

If the spec identified a prefactor task (and it hasn't been done), stop:

> "This issue depends on a prefactor that isn't complete yet. Work on #<prefactor issue> first."

If no prefactor is needed, continue.

## Phase 4: Map files

List every file the plan will touch before writing any tasks:

```
Create:   src/<path>
Modify:   src/<path> (lines ~N–M)
Test:     tests/<path>
```

Mirror existing test file structure. If a test directory doesn't exist yet, note it — setup is Task 1.

## Phase 5: Write tasks

Decompose into behaviors. Each task = one behavior, one red-green-refactor cycle.

**Right size:** A task takes 2–5 minutes. If it's larger, split it. If two tasks always pass or fail together, merge them.

**Never write all tests first then all implementation (horizontal slicing).** Each task is complete — test, implementation, and commit — before the next task begins.

The red-green-refactor loop itself lives in `/tdd`. The plan carries only the per-task specifics `/tdd` needs. For each task:

```markdown
### Task N: <Behavior Name>

**Files:** `exact/path/to/file` — test: `exact/path/to/test`
**Behavior:** One sentence — the observable thing this task proves works.
**Test asserts:** <inputs → expected output, including the edge case>
**Expected RED:** `<expected failure message>` from `<exact test command>`
**Implementation:** <signature/approach in one line; the seam it attaches to>
**Commit:** `<type>(<scope>): <description>`
```

**Rules for task content:**
- Describe the test and implementation in prose, do not write the code — `/tdd` writes it. State the assertion and approach precisely enough that there is one obvious implementation.
- The test command must be exact, and pair it with the expected failure message
- If a later task depends on a type or function defined in an earlier task, use the exact name defined there — no inconsistencies
- Each commit message follows conventional commits: `feat`, `fix`, `refactor`, `test`, `chore`

## Phase 6: Self-review

Before showing the plan to the user, check:

1. **Criteria coverage** — does every acceptance criterion from the issue map to at least one task?
2. **No placeholders** — no TBD, TODO, "similar to above", or vague steps
3. **Name consistency** — function/type names used in later tasks match what earlier tasks define
4. **Minimal scope** — does any task add behaviour beyond the acceptance criteria? Cut it.

Fix issues inline. Do not re-review after fixing.

## Phase 7: Confirm and post

Show the plan to the user. Wait for approval or changes.

Once approved, post as an issue comment:

```bash
gh issue comment $ARGUMENTS --body "$(cat <<'PLAN'
## Implementation Plan

> Run \`/tdd $ARGUMENTS\` to execute task by task, pausing for review between each.

**Goal:** <one sentence from issue>

**Spec:** `.claude/specs/YYYY-MM-DD-<topic>.md` *(local, gitignored)*

---

<paste approved task list here>
PLAN
)"
```

Report the comment URL from the output.

Also update the issue to show it is planned:

```bash
gh issue edit $ARGUMENTS --add-label "planned" 2>/dev/null || true
```

(Creates no error if the label doesn't exist.)

## Rules

- Never post a plan with vague or ambiguous steps — it will mislead the implementing agent
- Tasks run in strict order; later tasks may not assume anything not produced by earlier tasks
- The plan comment is the source of truth in new sessions — it must be self-contained enough to execute without the spec file
