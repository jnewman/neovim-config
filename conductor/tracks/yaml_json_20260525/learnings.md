# Track Learnings: yaml_json_20260525

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is the sole entry point that requires each module in order
- Nix module at `modules/neovim.nix` owns all plugin declarations via `programs.neovim.plugins`; Lua files are symlinked into `~/.config/nvim/lua/` via `xdg.configFile."nvim/lua"`
- `nix fmt` auto-formats all `.nix` files via the `formatter` output in `flake.nix`

---

<!-- Learnings from implementation will be appended below -->
