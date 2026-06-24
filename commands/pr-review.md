---
name: pr-review
description: Review a PR or the current diff for bugs, correctness, and quality
---

If given a GitHub PR URL or number, fetch the diff with `gh pr diff <number>` first.
If reviewing local changes, use `git diff main...HEAD`.

Review for:
1. **Bugs** — logic errors, null/undefined, off-by-ones, race conditions
2. **Correctness** — does it do what it says? Are edge cases handled?
3. **TypeScript** — no `any`, proper typing, no unsafe casts
4. **React/Next.js** — unnecessary client components, missing keys, useEffect misuse, server/client boundary issues
5. **Simplicity** — premature abstractions, unnecessary complexity

Format findings as:
- **[MUST]** bugs or correctness issues that block merging
- **[SHOULD]** quality improvements worth doing in this PR
- **[NIT]** minor style issues, deprioritize if there are MUSTs

If there are no findings in a category, skip it. Be direct — no filler.
