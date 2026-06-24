---
name: init-docs
description: Scaffold or update the docs/ directory for the current project. Creates docs/overview.md (high-level context) and docs/<module>.md files (module-level specifics). Follows the doc conventions in CLAUDE.md.
---

# init-docs

Scaffold or update the `docs/` directory for the current project.

## Steps

1. **Survey the project** -- read root files (`package.json`, `README*`, `tsconfig.json`, entry points) and list top-level directories to understand structure. Do not read everything; sample enough to identify modules.

2. **Identify modules** -- a module is any cohesive domain with its own directory or clear boundary (e.g. `auth`, `api`, `db`, `ui`, `workers`). Aim for 3-8 modules; avoid over-splitting.

3. **Create `docs/overview.md`** if it does not exist (update it if it does):
   - What the project does (1-2 lines)
   - Tech stack (bullet list)
   - Module index: name + one-line description for each module
   - No prose. Grammar optional. Never ambiguous.

4. **Create `docs/<module>.md`** for each identified module if it does not exist (update if it does):
   - Purpose (1 line)
   - Key files: `path/to/file.ts` -- what it does
   - Important decisions or constraints (only non-obvious ones)
   - Related docs: links to other module docs that are tightly coupled
   - No prose. Grammar optional. Never ambiguous.

## Doc format rules

- Bullet points over sentences.
- File paths must be relative to project root and accurate.
- If a file path is uncertain, verify it exists before writing it.
- Never pad with obvious information (e.g. "this is the main entry point" for `index.ts`).
- Keep each doc under 40 lines. If a module is complex, split it into sub-modules rather than expanding the doc.
