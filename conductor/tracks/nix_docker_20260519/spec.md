# Spec: Migrate Nix Build to Docker

*Last Revised: 2026-05-19 (Revision 1 — plugin-pack approach after Task 1 audit)*

## Overview

Replace host-installed Nix with the official `nixos/nix` Docker image for all build
operations. Neovim and host tools (LSPs, formatters) are installed via Homebrew. Nix/Docker
is used exclusively to build a Neovim plugin pack — a `pack/nix/start/` tree of pure-Lua
plugin files that the host nvim loads via its packpath.

This approach achieves a completely Nix-free host (no `/nix` directory, no daemon, no CLI)
while retaining reproducible, Nix-declared plugin management.

## Functional Requirements

1. **Remove host Nix** — Uninstall Nix from the host; no Nix daemon, no `/nix` store.
2. **Restructure flake.nix** — Replace home-manager config with a `packages.nvim-plugin-pack`
   (and `.default`) output that produces a `pack/nix/start/` tree of Neovim plugin directories
   (pure Lua/VimL files, no store-path references).
3. **Host tools via Homebrew** — nvim binary, LSP servers (lua-language-server, nixd),
   formatters (stylua, nixfmt), and gh installed on host via Homebrew. Declared in a
   `Brewfile` committed to the repo.
4. **`task build`** — Launches the official `nixos/nix` Docker image, mounts the repo,
   runs `nix build .#nvim-plugin-pack`, copies the plugin pack to a staging path inside
   the container.
5. **`task install`** — Uses `docker cp` to copy the plugin pack to
   `~/.local/share/nvim/site/` on the host. Symlinks `~/.config/nvim/lua` → `<repo>/lua/`
   and writes `~/.config/nvim/init.lua` from the repo.
6. **CI update** — GitHub Actions workflow updated to use the official `nixos/nix` Docker
   image instead of `DeterminateSystems/nix-installer-action`.

## Non-Functional Requirements

- Reproducible: same `flake.lock` → same plugin versions.
- Host stays completely clean: no `/nix` directory, no Nix daemon process.
- Docker layer caching keeps rebuild times reasonable.
- Homebrew dependency list is version-controlled in `Brewfile`.

## Acceptance Criteria

- [ ] `which nix` on the host returns nothing (Nix fully removed).
- [ ] `task build` completes; plugin pack exists inside the container.
- [ ] `task install` copies plugin pack to `~/.local/share/nvim/site/` without error.
- [ ] `~/.config/nvim/lua` is symlinked to `<repo>/lua/`; `init.lua` is in place.
- [ ] `nvim` (from Homebrew) launches with plugins loading from the pack directory.
- [ ] LSPs (lua-language-server, nixd) and formatters (stylua, nixfmt) work via Homebrew installs.
- [ ] `flake.nix` no longer depends on home-manager; exposes `packages.nvim-plugin-pack`.
- [ ] CI passes on GitHub Actions using the new Docker-based workflow.
- [ ] `Brewfile` lists all host tool dependencies.

## Out of Scope

- Switching plugin management to lazy.nvim or Mason — Nix continues to declare plugins.
- Automated rebuilds via git hooks or watch mode — manual `task build` only.
- Publishing the Docker image to a registry.
- Multi-machine / remote deployment of the built config.
- Managing nvim dotfiles for multiple users or machines.
