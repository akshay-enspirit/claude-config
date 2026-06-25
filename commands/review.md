---
name: review
description: Review a local diff or PR for issues beyond what TypeScript and linting catch — security, logic flaws, bad patterns, architectural problems.
---

Code review focused on what automated tools miss. Run this after any meaningful change — after a TDD session, before a PR, or whenever you want a quality check.

Optional: PR number or branch name — `$ARGUMENTS`

**Do not auto-fix anything. The user decides what to address and when.**

## Phase 1: Get the diff

Determine what `$ARGUMENTS` is:
- **PR number** — `$ARGUMENTS` is a positive integer only (e.g. `42`). Anything else is a branch name or empty.
- **Branch name** — any non-integer string
- **Empty** — no argument provided

**If PR number:**
```bash
gh pr diff $ARGUMENTS
gh pr view $ARGUMENTS
```
Combine the PR title, body, and linked issues with the diff before reviewing. The PR description states the intent — you need it to judge whether the logic is correct.

**If branch name:**
```bash
git diff $(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's/origin\///') ...$ARGUMENTS
```

**If empty:**
```bash
BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's/origin\///' || echo "main")
git diff $BASE...HEAD
git log $BASE...HEAD --oneline
```

**If the diff is empty, stop immediately:**
> "Diff is empty — either this branch has not diverged from the base, or you are already on the base branch. Nothing to review."

Do not proceed with an empty diff.

## Phase 2: Review

**Read full files, not just diffs.** For every non-trivial change, read the entire file — diffs hide class-level invariants, module contracts, and what deleted code was protecting. A diff-only review misses the most important issues.

**Check cross-file impact.** After reviewing individual files, check:
- Every caller of a changed function or method signature
- Every consumer of a changed module interface
- Any schema or config change against the code that reads it
- Any deleted code that other modules may have relied on

This cross-file pass is where the highest-severity bugs live. Do not skip it.

Look for issues that TypeScript, ESLint, and similar tools will not catch. Do not flag things those tools already enforce.

**Security**
- Injection vectors (SQL, command, path traversal)
- Auth/authz gaps — missing checks, privilege escalation paths
- Secrets or credentials in code or logs
- Unsafe deserialization or trust of external input
- Insecure defaults

**Logic**
- Conditions that are always true or always false
- Off-by-one errors, boundary conditions not handled
- Race conditions or state mutation across async boundaries
- Incorrect error propagation — errors swallowed, wrong error type returned
- Edge cases the tests don't exercise

**Design**
- Leaking implementation details through an interface that should be opaque
- Two modules that are now tightly coupled when they shouldn't be
- A narrow interface that became wide without justification
- Premature abstractions — indirection with no payoff yet
- Behavior added speculatively (YAGNI)

**Patterns**
- Inconsistent error handling style vs the rest of the codebase
- Naming that diverges from established conventions in this project
- A solved problem being re-solved in a new way without a reason

**Tests**
- New behavior added without a corresponding test
- Existing tests deleted or weakened without justification
- A test that passes trivially and wouldn't catch the bug it's named after

## Phase 3: Report

**Do not auto-fix anything. The user decides what to address and when.**

Group findings by severity:

**Critical** — must fix before this ships. Bugs, security issues, data loss risk.
**Important** — should fix in this change. Design problems, bad patterns that will compound.
**Minor** — worth noting but deprioritise if Criticals or Importants exist.

Use source line numbers from the current file, not diff-hunk line numbers.

Format:

```
## Review

### Critical
- **<file>:<source line>** — <finding>. <why it matters and what to do instead>.

### Important
- **<file>:<source line>** — <finding>.

### Minor
- **<file>:<source line>** — <finding>.
```

Skip any severity level with no findings.

If there are no findings worth raising, say so plainly: "No issues found."

Do not comment on style, formatting, or anything a linter handles.
Do not pad the review — if there are two real findings, report two.
