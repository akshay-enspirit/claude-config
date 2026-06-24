---
name: scaffold
description: Scaffold a new feature, component, API route, or service matching existing patterns
---

Before writing anything:
1. Find 1-2 existing similar files in the repo and read them fully — match their patterns exactly.
2. Identify the minimal set of files needed. Don't create speculative extras.

When scaffolding:
- Match naming, structure, and conventions of existing code exactly.
- TypeScript strict — no `any`, explicit types throughout.
- React: start as a server component. Add `'use client'` only if interactivity requires it.
- API routes: match existing error handling and response shape.
- Services/modules: match existing module structure and export style.

After scaffolding, list:
- What was created
- What the caller needs to wire up to make it functional
