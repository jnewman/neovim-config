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

## Gotcha: blink.cmp fuzzy binary is Linux-only

blink.cmp ships a Rust-compiled `libblinkfuzzy` for fuzzy matching. Nixpkgs builds it for the Docker target (aarch64-linux). It cannot run on the macOS host (aarch64-darwin) — same ABI constraint as treesitter parsers.

Fix: set `fuzzy = { implementation = "lua" }` in the blink.cmp setup to force the pure-Lua fallback. This works without any native binary. Performance is slightly lower but imperceptible for typical completion use.

**Rule for future plugins:** Any plugin with a Rust/C compiled component (fzf-native, blink.cmp fuzzy, etc.) needs either a Lua fallback or a separate macOS build step. Check plugin docs for a `lua` implementation option before adding.

---
