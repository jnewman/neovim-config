# Tech Stack: neovim-config

## Editor

- **Neovim** — installed via Homebrew on the host

## Configuration Language

- **Lua** — all configuration written in Lua

## Package Management

- **Nix flakes** — builds the plugin pack inside the official `nixos/nix` Docker image; no Nix on the host
- **Homebrew** — manages host tools: Neovim, lua-language-server, stylua, gh, yaml-language-server, yq
- **npm** — jsonls installed via `npm install -g vscode-langservers-extracted`
- **Docker** — `nixos/nix` container used for builds; `docker cp` transfers the pack to the host

## Language Servers (LSP)

All LSP servers run inside the `nvim-lsp` Docker container. Neovim communicates via
`docker exec -i nvim-lsp <binary>`. The container is built with `task lsp-build` and
starts automatically at login via launchd (macOS) or systemd (Linux).

| Language   | Server                         | Install method (inside container) |
|------------|--------------------------------|-----------------------------------|
| Lua        | lua-language-server            | Homebrew (host)                   |
| YAML       | yaml-language-server           | Homebrew (host)                   |
| JSON       | vscode-json-languageserver     | npm (host)                        |
| Python     | pyright                        | npm (container)                   |
| Rust       | rust-analyzer                  | rustup (container)                |
| TypeScript | typescript-language-server     | npm (container)                   |
| Go         | gopls                          | go install (container)            |
| Scala      | metals                         | Coursier (container)              |
| Haskell    | haskell-language-server        | GHCup (container)                 |
| Ruby       | ruby-lsp                       | gem (container)                   |
| C          | clangd                         | apt (container)                   |
| Bash       | bash-language-server           | npm (container)                   |
| HTML       | vscode-html-languageserver     | npm (container)                   |
| XML        | lemminx                        | binary release (container)        |
| HCL        | terraform-ls                   | HashiCorp release (container)     |

## Formatters

| Language   | Tool              | Install method                              |
|------------|-------------------|---------------------------------------------|
| Lua        | stylua            | Homebrew (host)                             |
| Nix        | nixfmt            | Nix devShell (CI)                           |
| YAML       | yq                | Homebrew (host)                             |
| JSON       | yq                | Homebrew (host)                             |
| Python     | ruff format       | pip (container)                             |
| Rust       | rustfmt           | rustup (container)                          |
| TypeScript | prettier          | npm (container)                             |
| Go         | gofmt             | Go stdlib (container)                       |
| Scala      | scalafmt          | Coursier (container)                        |
| Haskell    | ormolu            | cabal (container)                           |
| Ruby       | rubocop           | gem (container)                             |
| C          | clang-format      | apt (container)                             |
| Bash       | shfmt             | go install (container)                      |
| HTML       | prettier          | npm (container)                             |
| XML        | xmllint           | apt libxml2-utils (container)               |
| HCL        | terraform fmt     | HashiCorp release (container)               |

## Core Plugins

| Plugin | Role |
|--------|------|
| catppuccin-nvim | Colorscheme (Mocha default, toggled via `<leader>tt`) |
| cyberdream-nvim | Colorscheme — neon cyberpunk |
| tokyonight-nvim | Colorscheme — deep blue/purple |
| nvim-treesitter | Syntax highlighting (parsers installed natively via `:TSInstall`) |
| SchemaStore-nvim | JSON/YAML schema catalog for LSP validation (via Nix) |
| conform-nvim | Formatter integration |
| telescope-nvim + plenary-nvim | Fuzzy finder |
| gitsigns-nvim | Git signs in gutter |
| diffview-nvim | Git diff and history viewer |
| octo-nvim | GitHub PRs and issues inside Neovim |

## Dev Tasks (Taskfile)

| Task | Command |
|------|---------|
| `task fmt` | `stylua .` + `nix fmt` |
| `task lint` | `stylua --check .` + `nix fmt -- --check` |
| `task test` | `luacheck lua/` + `nvim --headless -u lua/init.lua +qa` |

## CI

- **GitHub Actions** — `lint` and `test` jobs run in parallel on every push inside `nixos/nix` Docker container via `docker run`
- **devShell** — `nix develop` exposes `luacheck` and `neovim` for local task runs
- **`.luacheckrc`** — configures Neovim globals (`vim`, `require`, etc.) for luacheck
