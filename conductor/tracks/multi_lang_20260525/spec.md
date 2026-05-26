# Spec: Multi-Language Support

## Overview

Add full-stack language support for 12 languages: Scala, Python, Rust,
TypeScript, Go, XML, HTML, Haskell, Bash, HCL, Ruby, and C.

"Full-stack" means three components per language:
1. **Treesitter** — syntax highlighting and indentation
2. **LSP** — diagnostics, completions, go-to-definition, hover
3. **Formatter** — auto-format on save via conform.nvim

All LSP servers and formatters are installed in a single Docker image.
Neovim communicates with them via `docker exec` on a long-running container
that starts at login on both macOS and Linux.

## Functional Requirements

### 1. Docker LSP/Formatter Image
- A `Dockerfile` at the repo root builds a minimal image containing all
  12 LSP servers and their formatters
- Container started automatically at login:
  - macOS: launchd plist (`~/Library/LaunchAgents/nvim-lsp.plist`)
  - Linux: systemd user service (`~/.config/systemd/user/nvim-lsp.service`)
- Container name: `nvim-lsp`
- A helper script (`scripts/lsp-start.sh`) manages lifecycle: creates if
  absent, starts if stopped, no-ops if already running

### 2. Treesitter Parsers
- `lua/config/treesitter.lua` `ensure_installed` extended for all 12 languages
- Parsers installed natively by Neovim on first launch

### 3. LSP Configuration
- Each language added to `lua/config/lsp.lua` using `vim.lsp.config` +
  `vim.lsp.enable` (existing native Neovim 0.10+ pattern)
- All LSP `cmd` values: `{ "docker", "exec", "-i", "nvim-lsp", "<binary>", ... }`
- `root_markers` set per language convention

### 4. Formatter Configuration
- Each language added to `lua/config/format.lua` via conform.nvim
- Formatters invoked via `docker exec -i nvim-lsp <formatter>` with `stdin = true`
- Formatters requiring config discovery (scalafmt, rubocop, clang-format) use
  explicit flags to operate statelessly on stdin

### 5. Documentation
- `conductor/tech-stack.md` updated with all new LSP and formatter rows

## LSP / Formatter Matrix

| Language   | Treesitter Parser(s)       | LSP Server                     | Formatter       |
|------------|----------------------------|--------------------------------|-----------------|
| Python     | `python`                   | `pyright`                      | `ruff format`   |
| Rust       | `rust`                     | `rust-analyzer`                | `rustfmt`       |
| TypeScript | `typescript`, `tsx`        | `typescript-language-server`   | `prettier`      |
| Go         | `go`, `gomod`, `gowork`    | `gopls`                        | `gofmt`         |
| Scala      | `scala`                    | `metals`                       | `scalafmt`      |
| Haskell    | `haskell`                  | `haskell-language-server`      | `ormolu`        |
| Ruby       | `ruby`                     | `ruby-lsp`                     | `rubocop`       |
| C          | `c`                        | `clangd`                       | `clang-format`  |
| Bash       | `bash`                     | `bash-language-server`         | `shfmt`         |
| HTML       | `html`                     | `vscode-html-languageserver`   | `prettier`      |
| XML        | `xml`                      | `lemminx`                      | `xmllint`       |
| HCL        | `hcl`                      | `terraform-ls`                 | `terraform fmt` |

## Non-Functional Requirements

- Container starts in < 5 seconds
- `docker exec` LSP spawn overhead < 500ms (one-time per language per session)
- No new Neovim plugins required
- Dockerfile uses a minimal base image (debian:bookworm-slim)

## Acceptance Criteria

- Opening a file of each type triggers LSP attach (`:LspInfo` shows active server)
- Diagnostics, completions, hover (`K`), and go-to-def (`gd`) work per language
- `<leader>cf` formats a file of each type without error
- Container starts automatically at login; survives Neovim restarts
- Treesitter highlights active for all 12 filetypes

## Out of Scope

- DAP / debugger integration
- Language-specific linting beyond what the LSP provides
- Remote/SSH development
- Windows host support
