# neovim-config

Joshua's Neovim configuration. Plugins are built inside a Docker container using Nix; Neovim and language tooling run on the host via Homebrew.

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/) — for building the plugin pack
- [Homebrew](https://brew.sh) — for Neovim and language tooling
- [Task](https://taskfile.dev) — task runner (`brew install go-task`)

No Nix on the host is required.

## Setup

```bash
task setup
```

This installs host tools via Homebrew, builds the plugin pack inside Docker, and wires config symlinks. On first launch run `:TSInstall` to compile tree-sitter parsers natively.

## Daily workflow

```bash
task build    # Rebuild plugin pack (after changes to modules/plugins.nix)
task install  # Re-install pack and refresh symlinks
task update   # Update all flake inputs (flake.lock committed on host via bind-mount)
task fmt      # Format Lua and Nix files
task lint     # Check formatting without modifying files
task test     # Run luacheck
```

## Project layout

```
flake.nix           # Flake entry — produces packages.nvim-plugin-pack and devShells.default
modules/
  plugins.nix       # Plugin list — plain Nix expression, no home-manager
Brewfile            # Host tool dependencies
Taskfile.yml        # All build / install / dev tasks
lua/
  init.lua          # Entry point — loads all config modules
  config/
    options.lua     # Editor options (line numbers, tabs, clipboard, …)
    keymaps.lua     # Key mappings
    autocmds.lua    # Auto-commands
    colorscheme.lua # Theme setup and light/dark toggle
    lsp.lua         # LSP config (lua_ls via Homebrew lua-language-server)
    format.lua      # conform.nvim formatters
    treesitter.lua  # Tree-sitter config (parsers installed natively via :TSInstall)
    gitsigns.lua    # Git signs config
    diffview.lua    # Diffview config
    octo.lua        # GitHub Octo config
stylua.toml         # Lua formatter config
```

## Plugins

| Plugin | Role |
|--------|------|
| [catppuccin-nvim](https://github.com/catppuccin/nvim) | Colorscheme — Mocha (default) |
| [cyberdream-nvim](https://github.com/scottmckendry/cyberdream.nvim) | Colorscheme — neon cyberpunk |
| [tokyonight-nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme — deep blue/purple |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting (parsers installed via `:TSInstall`) |
| [conform-nvim](https://github.com/stevearc/conform.nvim) | Formatter integration |
| [telescope-nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [plenary-nvim](https://github.com/nvim-lua/plenary.nvim) | Telescope dependency |
| [gitsigns-nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in the gutter |
| [diffview-nvim](https://github.com/sindrets/diffview.nvim) | Git diff and history viewer |
| [octo-nvim](https://github.com/pwntester/octo.nvim) | GitHub PRs and issues in Neovim |

## Host tools (Homebrew)

| Tool | Purpose |
|------|---------|
| `neovim` | Editor |
| `lua-language-server` | Lua LSP |
| `stylua` | Lua formatter |
| `gh` | GitHub CLI (used by octo.nvim) |

## Key mappings

| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | Normal | Clear search highlight |
| `<C-h/j/k/l>` | Normal | Navigate windows |
| `<` / `>` | Visual | Indent and reselect |
| `J` / `K` | Visual | Move selection down / up |
| `n` / `N` | Normal | Next/prev search result (centred) |
| `<leader>tt` | Normal | Cycle colorscheme |
