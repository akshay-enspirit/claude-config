---
name: spec
description: Plan a module or feature before writing any code. Explores requirements, writes a local spec, then creates GitHub milestone and issues.
---

Plan what you're building before touching code. Produces a local spec and GitHub issues that serve as the durable cross-session record.

If `$ARGUMENTS` is not empty, use it as the initial topic and skip asking what to build.

<HARD-GATE>
Do NOT create GitHub issues, write code, or proceed to /plan until the spec is approved by the user.
</HARD-GATE>

## Phase 1: Orient

Read these before asking anything:

```bash
cat CLAUDE.md 2>/dev/null
cat docs/overview.md 2>/dev/null
git log --oneline -10
```

If the topic (from `$ARGUMENTS` or the user) maps to an existing `docs/<module>.md`, read it too.

## Phase 2: Scope

Ask ONE question, wait for the answer:

> "Is this a **module** (internal technical component — no direct user-facing change) or a **feature** (user-facing, likely spans multiple issues and needs a milestone)?"

## Phase 3: Clarify

Ask questions **one at a time**. Wait for each answer before asking the next. Aim for 3–5 questions total — stop when you can write a clear spec.

**For modules**, cover in order:
1. What does this replace or extend?
2. What consumes it, and what does the interface look like?
3. What invariants must it hold?

**For features**, cover in order:
1. What problem does this solve from the user's perspective?
2. What does success look like — what can the user do that they couldn't before?
3. What's the simplest slice that delivers real value?
4. What are the hard constraints (performance, compatibility, breaking changes)?

## Phase 4: Prefactor check

Before proposing an approach, ask:

> "Is there anything in the current codebase that makes this harder than it should be — worth untangling first?"

If yes: that becomes a prefactor issue created before the feature issues, with an explicit "blocked by" chain.

## Phase 5: Propose approach

Present 2–3 approaches with trade-offs. Lead with your recommendation and state why. Wait for approval before writing the spec.

If scope spans multiple independent subsystems, decompose now. Each sub-spec runs `/spec` separately.

## Phase 6: Write spec

Ensure `.claude/specs/` exists and is gitignored:

```bash
mkdir -p .claude/specs
grep -qF '.claude/specs' .gitignore 2>/dev/null || echo '.claude/specs/' >> .gitignore
```

Save to `.claude/specs/YYYY-MM-DD-<kebab-topic>.md`:

```markdown
# <Topic>

## Problem
One paragraph. What is being solved and why.

## Approach
The chosen approach and the reasoning behind it.

## Acceptance Criteria
- [ ] <observable, testable behavior>
- [ ] <observable, testable behavior>

## Out of Scope
What is explicitly not being done in this change.

## Key Files
<path or module>: <one-line responsibility>
```

**Self-review before showing the spec:**
- Any vague or untestable acceptance criterion? Make it concrete.
- Any contradiction between approach and criteria? Resolve it.
- Any placeholder or TBD? Fill in or cut.

Show the spec to the user. Iterate until approved.

## Phase 7: GitHub issues

<HARD-GATE>
Do not run any `gh` commands until the user approves the spec.
</HARD-GATE>

**For features — create milestone first:**

```bash
gh milestone create \
  --title "<Feature Name>" \
  --description "<one sentence>"
```

Note the milestone number from the output (e.g. `Milestone #3 created`).

**Create issues in dependency order (blockers first):**

Each issue is one vertical slice — the thinnest end-to-end behavior that can be independently implemented and verified. In a monorepo where layers must be sequenced (e.g., API before UI), horizontal sequencing is acceptable; make the dependency explicit.

```bash
gh issue create \
  --title "<slice title>" \
  --milestone <number> \
  --body "$(cat <<'EOF'
## Context
Spec: .claude/specs/YYYY-MM-DD-<topic>.md

## What to build
<concise description of what this slice delivers end-to-end>

## Acceptance Criteria
- [ ] <criterion this slice must satisfy>

## Blocked by
#<issue number>, or: None — can start immediately.
EOF
)"
```

For modules: list open milestones and ask which one applies (`gh milestone list`). Valid options include "Tech Debt", "Setup", or any existing milestone. Every issue must be under a milestone.

**After all issues are created, print a summary:**

```
Spec:     .claude/specs/YYYY-MM-DD-<topic>.md
Milestone: <name> (#N)
Issues:
  #12 — <title> (no blockers)
  #13 — <title> (blocked by #12)
```

## Rules

- One question per message, always
- All issues must be under a milestone
- Acceptance criteria must be observable and testable — never vague
- Never create issues for out-of-scope items
- The local spec is the working surface; the GitHub issue is the durable record
- Prefactor issues, if any, are created first with explicit blocking relationships
