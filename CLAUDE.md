# About
Solo founder. TypeScript/Node backend, React/Next.js frontend. Working across 100+ repos, owning everything end to end.

# Behavior
- Concise responses. No trailing summaries of what you just did — I can read the diff.
- No comments unless the WHY is non-obvious (a hidden constraint, a workaround, a subtle invariant).
- No abstractions beyond what the task requires. Three similar lines beats a premature helper.
- Prefer editing existing files over creating new ones.
- No feature flags, backwards-compat shims, or error handling for impossible scenarios.
- Always check existing patterns in the codebase before introducing new ones.
- Never push to git without being explicitly asked.

# TypeScript
- Assume strict mode — no implicit any, explicit return types on exported functions.
- Named exports preferred over default exports.
- Prefer `type` over `interface` unless extending.
- Run `tsc --noEmit` after edits when tsconfig.json is present.

# React / Next.js
- App Router: server components by default. Add `'use client'` only when needed.
- No unnecessary `useEffect` — prefer derived state or server-side logic first.
- Colocate types with their usage.

# Git
- Commit messages focus on the why, not the what.
- Never commit or push unless explicitly asked.
