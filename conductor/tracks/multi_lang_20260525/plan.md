# Plan: Multi-Language Support

## Phase 1: Docker Image & Auto-Start
<!-- execution: parallel -->
<!-- depends: -->

- [x] Task 1: Write Dockerfile
  - Base: `debian:bookworm-slim`
  - Install all 12 LSP servers and formatters (Node/npm for typescript-language-server,
    bash-language-server, vscode-html-languageserver, lemminx, prettier, pyright;
    Go + gopls + gofmt; Rust toolchain + rust-analyzer + rustfmt; Python + ruff;
    Coursier for metals + scalafmt; GHCup for haskell-language-server + ormolu;
    gem for ruby-lsp + rubocop; llvm/clangd + clang-format; terraform + terraform-ls;
    shfmt; libxml2-utils for xmllint)
  - Acceptance: `docker build -t nvim-lsp .` succeeds; spot-check
    `docker run --rm nvim-lsp pyright --version` and
    `docker run --rm nvim-lsp gopls version`
  <!-- files: Dockerfile -->

- [x] Task 2: Write scripts/lsp-start.sh
  - OS detection (macOS vs Linux)
  - Creates container if absent, starts if stopped, no-ops if already running
  - Container name: `nvim-lsp`
  - Acceptance: script is idempotent; `docker ps` shows `nvim-lsp` after run
  <!-- files: scripts/lsp-start.sh -->
  <!-- depends: task1 -->

- [x] Task 3: Write macOS launchd plist
  - Path: `config/nvim-lsp.plist` (user copies to `~/Library/LaunchAgents/`)
  - Calls `scripts/lsp-start.sh` at login
  - Acceptance: `launchctl load` succeeds; container starts on login
  <!-- files: config/nvim-lsp.plist -->
  <!-- depends: task2 -->

- [x] Task 4: Write Linux systemd user service
  - Path: `config/nvim-lsp.service` (user copies to `~/.config/systemd/user/`)
  - Calls `scripts/lsp-start.sh` at login
  - Acceptance: `systemctl --user enable nvim-lsp` succeeds
  <!-- files: config/nvim-lsp.service -->
  <!-- depends: task2 -->

- [ ] Task 5: Conductor - User Manual Verification 'Docker Image & Auto-Start' (Protocol in workflow.md)

---

## Phase 2: Neovim Integration
<!-- execution: parallel -->
<!-- depends: phase1 -->

- [x] Task 1: Update lua/config/treesitter.lua
  - Extend `ensure_installed` with parsers: `python`, `rust`, `typescript`, `tsx`,
    `go`, `gomod`, `gowork`, `scala`, `haskell`, `ruby`, `c`, `bash`, `html`, `xml`, `hcl`
  - Acceptance: `:TSInstall` for each parser succeeds; syntax highlights active
    in test files for each filetype
  <!-- files: lua/config/treesitter.lua -->

- [x] Task 2: Update lua/config/lsp.lua
  - Add `vim.lsp.config` + `vim.lsp.enable` for all 12 languages
  - All `cmd` use `{ "docker", "exec", "-i", "nvim-lsp", "<binary>", ... }`
  - Set appropriate `root_markers` per language
  - Acceptance: `:LspInfo` shows active server when opening a file of each filetype
  <!-- files: lua/config/lsp.lua -->

- [x] Task 3: Update lua/config/format.lua
  - Add conform.nvim entries for all 12 languages
  - All formatters use `command = "docker"`, `args = { "exec", "-i", "nvim-lsp", "<formatter>", ... }`,
    `stdin = true`
  - Acceptance: `<leader>cf` formats without error for each filetype
  <!-- files: lua/config/format.lua -->

- [ ] Task 4: Conductor - User Manual Verification 'Neovim Integration' (Protocol in workflow.md)

---

## Phase 3: Documentation
<!-- execution: sequential -->
<!-- depends: -->

- [x] Task 1: Update conductor/tech-stack.md
  - Add all 12 languages to the LSP and Formatters tables
  - Acceptance: tables are accurate and complete
  <!-- files: conductor/tech-stack.md -->

- [ ] Task 2: Conductor - User Manual Verification 'Documentation' (Protocol in workflow.md)
