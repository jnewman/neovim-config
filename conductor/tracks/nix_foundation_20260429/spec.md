# Spec: MVP Foundation — Nix Flake + home-manager Neovim base

**Track ID:** nix_foundation_20260429

## Goal

Establish the Nix flake scaffold that all future Neovim configuration will live inside. At the
end of this track, Neovim should launch successfully via `nix run` (or home-manager activation)
with base options, sensible keymaps, and a working colorscheme — no plugins beyond what is
needed to prove the structure works.

## Scope

### In Scope

- `flake.nix` with nixpkgs and home-manager inputs
- A home-manager module that declares `programs.neovim.enable = true`
- Base Neovim options (`lua/config/options.lua`): line numbers, clipboard, tabs, etc.
- Base keymaps (`lua/config/keymaps.lua`): close to Vim defaults, minimal additions
- A colorscheme declared and applied via Nix
- `stylua.toml` and `nixfmt` configured for formatting
- `flake.lock` committed

### Out of Scope

- LSP, DAP, Telescope, file tree — deferred to subsequent tracks
- Per-language tooling
- Any plugin beyond the colorscheme

## Acceptance Criteria

1. `nix run` (or `nix develop` + `nvim`) launches Neovim without errors
2. Line numbers, relative numbers, and configured tab width are visible
3. Colorscheme applies correctly in both terminal and (if applicable) GUI
4. `stylua` and `nixfmt` are available in the dev shell
5. No Vimscript in the config — 100% Lua for runtime config, Nix for packaging

## Constraints

- All plugins and tools must be Nix-managed — no `:Lazy`, no manual installs
- Lua config must pass `stylua --check`
- Nix files must pass `nixfmt --check`
