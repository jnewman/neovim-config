# Track Learnings: reusability_20260525

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is the sole entry point
- Taskfile tasks are composable — `setup` calls `build` and `install` as sub-tasks
- No hardcoded absolute paths found in Lua files at track creation time (only in Taskfile.yml)
- `install` task uses `rm -rf` + re-create pattern which is effectively idempotent

---

<!-- Learnings from implementation will be appended below -->
