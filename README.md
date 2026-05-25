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
    options.lua     # Editor options
    keymaps.lua     # Key mappings
    autocmds.lua    # Auto-commands
    colorscheme.lua # Theme setup and toggle
    lsp.lua         # lua_ls config
    format.lua      # conform.nvim formatters
    treesitter.lua  # Tree-sitter (parsers via :TSInstall)
    completion.lua  # blink.cmp
    autopairs.lua   # nvim-autopairs
    oil.lua         # oil.nvim file explorer
    which-key.lua   # which-key.nvim keymap legend
    comment.lua     # Comment.nvim
    lualine.lua     # lualine statusline
    ibl.lua         # indent-blankline
    flash.lua       # flash.nvim jump navigation
    gitsigns.lua    # gitsigns
    diffview.lua    # diffview
    octo.lua        # GitHub Octo
stylua.toml         # Lua formatter config
```

## Plugins

| Plugin | Role |
|--------|------|
| [catppuccin-nvim](https://github.com/catppuccin/nvim) | Colorscheme — Mocha (default) |
| [cyberdream-nvim](https://github.com/scottmckendry/cyberdream.nvim) | Colorscheme — neon cyberpunk |
| [tokyonight-nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme — deep blue/purple |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Completion engine |
| [conform-nvim](https://github.com/stevearc/conform.nvim) | Formatter integration |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets and quotes |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comment toggling |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer as an editable buffer |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap prefix legend |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [flash.nvim](https://github.com/folke/flash.nvim) | Jump-to-anywhere navigation |
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

### General

| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | Normal | Clear search highlight |
| `<C-h/j/k/l>` | Normal | Navigate windows |
| `<` / `>` | Visual | Indent and reselect |
| `J` / `K` | Visual | Move selection down / up |
| `n` / `N` | Normal | Next/prev search result (centred) |
| `<leader>tt` | Normal | Cycle colorscheme |
| `<leader>?` | Normal | Show buffer keymap legend (which-key) |

### Completion (blink.cmp)

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / prev item |
| `<CR>` | Accept item |
| `<C-e>` | Dismiss |
| `<C-Space>` | Show completion menu |
| `<C-d>` / `<C-u>` | Scroll docs down / up |

### File explorer (oil.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `-` | Normal | Open parent directory |
| `<CR>` | Normal | Open file or directory |
| `-` | Normal | Go up a directory |
| `_` | Normal | Open current working directory |
| `gs` | Normal | Sort |
| `g.` | Normal | Toggle hidden files |

### Jump navigation (flash.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `s` | Normal / Visual / Operator | Flash jump — type chars to jump to any match |
| `S` | Normal / Visual / Operator | Flash treesitter — jump to treesitter node |
| `r` | Operator | Remote flash — apply operator on remote location |
| `R` | Operator / Visual | Treesitter search |

### Commenting (Comment.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Visual | Toggle line comment on selection |
| `gb` | Visual | Toggle block comment on selection |
| `gcO` | Normal | Add comment above |
| `gco` | Normal | Add comment below |
| `gcA` | Normal | Add comment at end of line |

### LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gr` | Normal | Go to references |
| `K` | Normal | Hover docs |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Code action |
| `[d` / `]d` | Normal | Previous / next diagnostic |

### Git (gitsigns)

| Key | Mode | Action |
|-----|------|--------|
| `]h` / `[h` | Normal | Next / prev hunk |
| `<leader>hs` | Normal / Visual | Stage hunk |
| `<leader>hr` | Normal / Visual | Reset hunk |
| `<leader>hS` | Normal | Stage buffer |
| `<leader>hu` | Normal | Undo stage hunk |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame line |
| `<leader>hd` | Normal | Diff this file |
| `ih` | Operator / Visual | Select hunk (text object) |

### Git (diffview)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gd` | Normal | Open diff view (working tree) |
| `<leader>gh` | Normal | File git history |
| `<leader>gH` | Normal | Branch git history |
| `<leader>gc` | Normal | Close diffview |

### GitHub (octo.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gpl` | Normal | List PRs |
| `<leader>gpo` | Normal | Open PR |
| `<leader>gpc` | Normal | Create PR |
| `<leader>grs` | Normal | Start PR review |
| `<leader>grS` | Normal | Submit PR review |
| `<leader>gil` | Normal | List issues |
