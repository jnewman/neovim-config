# Track Learnings: ci_tooling_20260518

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is the sole entry point
- Nix module at `modules/neovim.nix` owns all plugin declarations; Lua files symlinked via `xdg.configFile."nvim/lua"`
- `nix fmt` auto-formats all `.nix` files via the `formatter` output in `flake.nix` (nixfmt-rfc-style)
- stylua and nixfmt are already in `extraPackages` in `modules/neovim.nix`

---

<!-- Learnings from implementation will be appended below -->
