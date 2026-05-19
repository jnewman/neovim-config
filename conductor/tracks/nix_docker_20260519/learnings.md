# Track Learnings: nix_docker_20260519

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

From `nix_foundation_20260429`:

- `modules/neovim.nix` owns all plugin declarations via `programs.neovim.plugins`; Lua files
  are exposed to the host via `xdg.configFile."nvim/lua"` — this is what the new derivation
  must replicate without home-manager.
- `nixfmt-rfc-style` is wired as both a devShell package and the `formatter` output; `nix fmt`
  auto-formats all .nix files.
- Lua config lives in `lua/config/` with one file per concern; `lua/init.lua` is the entry
  point that requires each module.

---

<!-- Learnings from implementation will be appended below -->
