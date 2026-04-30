# Codebase Patterns

Reusable patterns discovered during development. Read this before starting new work.

## Code Conventions
- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is the sole entry point that requires each module in order (from: nix_foundation_20260429, 2026-04-29)
- Catppuccin `flavour = "auto"` respects `vim.o.background` — dark → Mocha, light → Latte. Toggle with `<leader>tt` via `vim.o.background` flip (from: nix_foundation_20260429, 2026-04-29)

## Architecture
- Nix module at `modules/neovim.nix` owns all plugin declarations via `programs.neovim.plugins`; Lua files are symlinked into `~/.config/nvim/lua/` via `xdg.configFile."nvim/lua"` (from: nix_foundation_20260429, 2026-04-29)
- `nix fmt` auto-formats all `.nix` files via the `formatter` output in `flake.nix` (nixfmt-rfc-style); no separate config file needed (from: nix_foundation_20260429, 2026-04-29)

## Gotchas
<!-- Patterns will be added as tracks are completed -->

## Testing
<!-- Patterns will be added as tracks are completed -->

---
Last refreshed: 2026-04-29
