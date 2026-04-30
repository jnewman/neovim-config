# Track Learnings: nix_foundation_20260429

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

<!-- No patterns yet - this is the first track -->

---

<!-- Learnings from implementation will be appended below -->

## [2026-04-29] - Phase 1-5 Summary: Track Complete
- **Implemented:** Full Nix flake scaffold with home-manager, base Lua config, catppuccin colorscheme, and formatting gates
- **Files changed:** flake.nix, modules/neovim.nix, lua/init.lua, lua/config/options.lua, lua/config/keymaps.lua, lua/config/autocmds.lua, lua/config/colorscheme.lua, stylua.toml
- **Learnings:**
  - Patterns: Lua config lives in `lua/config/` with one file per concern; `lua/init.lua` is the entry point that requires each module
  - Patterns: Nix module at `modules/neovim.nix` owns all plugin declarations via `programs.neovim.plugins`; Lua files are exposed via `xdg.configFile."nvim/lua"`
  - Patterns: `flavour = "auto"` in catppuccin respects `vim.o.background` — toggle with `<leader>tt`
  - Gotchas: Nix is not installed on the dev machine; all `nix flake update`, `nix develop`, `nix fmt`, and `home-manager switch` commands must be run by the user after installing Nix
  - Gotchas: `stylua` is only available inside `nix develop` — cannot verify formatting without Nix
  - Context: `nixfmt-rfc-style` is wired as both a devShell package and the `formatter` output; `nix fmt` auto-formats all .nix files
---

## [2026-04-29] - Phase 1 Task 2: Add flake.lock
- **Gotchas:** Nix is not installed on this machine. `nix flake update` and `nix develop` commands require the user to run them manually after installing Nix. All file authoring can proceed without Nix; only runtime verification tasks are blocked.
---
