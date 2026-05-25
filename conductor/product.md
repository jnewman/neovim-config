# Product Guide: neovim-config

## Vision

A focused, maintainable Neovim configuration. Plugins are managed declaratively via Nix (built
inside Docker, no Nix daemon on the host); Neovim and language tooling are installed via Homebrew.
The result is a reproducible setup that doesn't require Nix on the host machine.

## Target User

A developer who wants a reliable, Git-managed Neovim config with a simple install story:
Docker + Homebrew, nothing more.

## Core Features

- **Plugin management** — plugins declared in `modules/plugins.nix`, built inside Docker, installed
  to `~/.local/share/nvim/site/pack/nix/start/` via `docker cp`
- **LSP integration** — lua-language-server via Homebrew; completions and diagnostics in Lua files
- **Fuzzy finding** — telescope.nvim for files, grep, and buffers
- **Git tooling** — gitsigns (gutter), diffview (diffs/history), octo (PRs/issues in Neovim)
- **Syntax highlighting** — nvim-treesitter with parsers installed natively via `:TSInstall`
- **Formatting** — conform.nvim with stylua for Lua

## Configuration Approach

Plugins are declared as a Nix expression in `modules/plugins.nix` and built inside the official
`nixos/nix` Docker image. The resulting pack is copied to the host with `docker cp`. Lua config
files live in `lua/` and are symlinked into `~/.config/nvim/` by `task install`.

Host tools (Neovim, LSPs, formatters) are managed by Homebrew via `Brewfile`.

## Stability & Reproducibility

Nix flake inputs are pinned in `flake.lock` and committed, ensuring the plugin set is reproducible
across machines. Run `task update` to update all inputs and commit the new `flake.lock`.
