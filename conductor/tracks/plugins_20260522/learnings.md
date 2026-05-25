# Track Learnings: plugins_20260522

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

From `nix_docker_20260519`:

- Plugins are declared in `modules/plugins.nix` as `{ name = "..."; pkg = pkgs.vimPlugins.<attr>; }` entries.
- Each plugin gets a `lua/config/<name>.lua` file; all are required from `lua/init.lua`.
- The plugin pack is built inside Docker (`task build`) and installed via `docker cp` (`task install`).
- Nix-built binaries cannot run on the macOS host — only pure-Lua plugin files are safe to copy.
- `luacheck lua/` must pass with 0 warnings/errors before a task is complete.

---

<!-- Learnings from implementation will be appended below -->
