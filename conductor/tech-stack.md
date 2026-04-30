# Tech Stack: neovim-config

## Editor

- **Neovim** — latest stable (managed via nixpkgs)

## Configuration Language

- **Lua** — all configuration written in Lua

## Package Management

- **Nix flakes** — declarative, reproducible environment
- **home-manager** — manages Neovim, plugins, LSP servers, formatters, and debuggers as Nix packages

## Language Servers (LSP)

| Language           | Server           |
|--------------------|------------------|
| Python             | pyright          |
| JavaScript / TypeScript | ts-ls       |
| Go                 | gopls            |
| Rust               | rust-analyzer    |
| Scala              | metals           |

## Formatters / Linters

| Language           | Tool                        |
|--------------------|-----------------------------|
| Python             | ruff (format + lint)        |
| JavaScript / TypeScript | prettier               |
| Go                 | gofmt + goimports           |
| Rust               | rustfmt                     |
| Lua                | stylua                      |
| Nix                | nixfmt-rfc-style (via `nix fmt`) |

## Debuggers (DAP)

| Language           | Adapter     |
|--------------------|-------------|
| Python             | debugpy     |
| JavaScript / TypeScript | js-debug-adapter |
| Go                 | delve       |
| Rust               | codelldb    |

## Core Plugins

- **Colorscheme:** catppuccin-nvim (Mocha dark / Latte light, toggled via `<leader>tt`)
- **LSP:** nvim-lspconfig
- **Completion:** nvim-cmp (or blink.cmp)
- **Debugging:** nvim-dap + nvim-dap-ui
- **File Explorer:** nvim-tree or oil.nvim
- **Fuzzy Finding:** telescope.nvim
- **Treesitter:** nvim-treesitter
- **Git:** gitsigns.nvim, fugitive or neogit
- **Status Line:** lualine.nvim
