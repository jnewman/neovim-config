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

## [2026-05-19] - Phase 1: Restructure flake.nix (Tasks 1-4)

- **Implemented:** Removed home-manager; created `modules/plugins.nix` producing `packages.nvim-plugin-pack` via `pkgs.runCommand` + `cp -rL`; added Brewfile; removed nixd/nixfmt from Lua config.
- **Files changed:** flake.nix, modules/plugins.nix (new), modules/neovim.nix (deleted), modules/nix.nix (deleted), Brewfile (new), lua/config/lsp.lua, lua/config/format.lua
- **Commits:** e3102c6, 9fe1c94
- **Learnings:**
  - Gotchas: Nix-built binaries hardcode `/nix/store/...` paths — cannot `docker cp` nvim binary or LSP servers to a macOS host that has no Nix. Only pure-Lua plugin files are safely copyable.
  - Gotchas: `nvim-treesitter.withPlugins` produces a derivation whose `.dependencies` list contains parser derivations with `parser/lua.so` symlinks pointing back into `/nix/store`. These are Linux `.so` files; they do not run on macOS (aarch64-darwin). Use bare `pkgs.vimPlugins.nvim-treesitter` (no parsers); install parsers natively via `:TSInstall`.
  - Patterns: The `nixos/nix` Docker image needs `--extra-experimental-features "nix-command flakes"` and `--no-sandbox` to build flakes.
  - Patterns: `cp -rL` in `pkgs.runCommand` correctly dereferences store symlinks, producing a self-contained directory with plain files — safe to `docker cp`.
  - Context: `nixd` LSP requires `nix` on the host to evaluate Nix expressions — useless without host Nix. Removed from `lsp.lua`. Same for `nixfmt` in `format.lua`.
---
