# Tech Stack: neovim-config

## Editor

- **Neovim** — installed via Homebrew on the host

## Configuration Language

- **Lua** — all configuration written in Lua

## Package Management

- **Nix flakes** — builds the plugin pack inside the official `nixos/nix` Docker image; no Nix on the host
- **Homebrew** — manages host tools: Neovim, lua-language-server, stylua, gh
- **Docker** — `nixos/nix` container used for builds; `docker cp` transfers the pack to the host

## Language Servers (LSP)

| Language | Server |
|----------|--------|
| Lua | lua-language-server (via Homebrew) |

## Formatters

| Language | Tool |
|----------|------|
| Lua | stylua (via Homebrew) |
| Nix | nixfmt (via Nix devShell, for CI/formatting of flake files) |

## Core Plugins

| Plugin | Role |
|--------|------|
| catppuccin-nvim | Colorscheme (Mocha default, toggled via `<leader>tt`) |
| cyberdream-nvim | Colorscheme — neon cyberpunk |
| tokyonight-nvim | Colorscheme — deep blue/purple |
| nvim-treesitter | Syntax highlighting (parsers installed natively via `:TSInstall`) |
| conform-nvim | Formatter integration |
| telescope-nvim + plenary-nvim | Fuzzy finder |
| gitsigns-nvim | Git signs in gutter |
| diffview-nvim | Git diff and history viewer |
| octo-nvim | GitHub PRs and issues inside Neovim |

## CI

- **GitHub Actions** — lint (stylua + nixfmt check) and test (luacheck) run inside `nixos/nix` Docker container via `docker run` in workflow steps
