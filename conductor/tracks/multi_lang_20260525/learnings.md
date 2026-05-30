# Track Learnings: multi_lang_20260525

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is
  the sole entry point that requires each module in order
- All new LSP servers use `vim.lsp.config` + `vim.lsp.enable` (Neovim 0.10+
  native API) — do NOT add nvim-lspconfig
- conform custom formatters that need shell pipelines use `command = "sh"`,
  `args = { "-c", "..." }`, `stdin = true`
- `vscode-json-languageserver` (jsonls) has no Homebrew formula — install via
  `npm install -g vscode-langservers-extracted`

---

<!-- Learnings from implementation will be appended below -->

## [2026-05-25] - Phase 1: Docker Image & Auto-Start

- **Implemented:** Dockerfile (debian:bookworm-slim, all 12 LSPs + formatters), lsp-start.sh, launchd plist, systemd service, task lsp-build + task lsp-install
- **Files changed:** Dockerfile, scripts/lsp-start.sh, config/nvim-lsp.plist, config/nvim-lsp.service, Taskfile.yml
- **Learnings:**
  - Patterns: `ENV PATH=...` at top of Dockerfile ensures all tool bins are on PATH for `docker exec` calls — set it once before any installs
  - Patterns: launchd plist and systemd service both reference `/usr/local/bin/nvim-lsp-start` (installed by `task lsp-install` via symlink) rather than the repo path directly — keeps the config files portable
  - Gotchas: GHCup + HLS + ormolu makes the image very large (~5-8GB); build takes 20-40 min on first run
  - Gotchas: lemminx binary name inside the zip varies by arch (`lemminx` vs `lemminx-linux`) — use `mv /tmp/lemminx/lemminx* /usr/local/bin/lemminx` to handle both
  - Gotchas: `rustup component add rust-analyzer` requires `--no-modify-path` flag in non-interactive Docker builds to prevent rustup from modifying .bashrc

---

## [2026-05-25] - Phase 2: Neovim Integration

- **Implemented:** treesitter.lua (15 parsers), lsp.lua (12 new servers via docker exec), format.lua (12 new formatters via docker exec)
- **Files changed:** lua/config/treesitter.lua, lua/config/lsp.lua, lua/config/format.lua
- **Learnings:**
  - Patterns: `local function docker(binary, ...)` helper in lsp.lua keeps `vim.lsp.config` cmd lines DRY — use `vim.list_extend` to merge the varargs
  - Patterns: conform.nvim `args` as a function receives `(self, ctx)` — use `ctx.filename` for formatters that need `--stdin-filepath` / `--assume-filename`; use `function(_)` (drop ctx) when filename is not needed, or luacheck will warn about unused argument
  - Patterns: set `timeout_ms = 10000` on docker exec formatters — default 500ms is too short for first-run container exec overhead
  - Gotchas: rubocop `--stdin <filename> --autocorrect --format quiet` outputs only warnings/errors to stderr; the corrected source goes to stdout — works with conform `stdin = true`
  - Gotchas: `terraform fmt -` reads from stdin; the `-` flag is required

---

## [2026-05-25] - Phase 3: Documentation

- **Implemented:** tech-stack.md updated with full LSP and Formatter tables for all 15 languages
- **Files changed:** conductor/tech-stack.md

---

## [2026-05-27] - Dockerfile Build Fixes (task lsp-build)

- **Fixes applied:** 4 build failures resolved during Phase 1 verification
- **Files changed:** Dockerfile, lua/config/format.lua
- **Gotchas:**
  - `@xml-tools/server` does NOT exist on npm — remove it; XML LSP is lemminx (native binary), not an npm package
  - `BOOTSTRAP_HASKELL_MINIMAL=1` in GHCup bootstrap skips GHC installation entirely — omit it; without MINIMAL, GHCup installs GHC + cabal by default. Run `cabal update && cabal install ormolu` in the same RUN layer as the bootstrap so GHC is on PATH
  - Both `terraform` and `terraform-ls` zips contain a `LICENSE.txt`; `unzip -d /usr/local/bin/` prompts interactively to overwrite in Docker (gets EOF, exits 1) — use `unzip terraform.zip terraform -d /usr/local/bin/` to extract only the binary
  - lemminx has no ARM64 Linux native binary in any release — use the uber JAR from `https://download.eclipse.org/lemminx/releases/{version}/org.eclipse.lemminx-uber.jar` with a `java -jar` wrapper script; requires `default-jre-headless` in base apt install
  - `format_on_save.timeout_ms = 500` is the *overall* format timeout — docker exec formatters need `10000`; the per-formatter `timeout_ms` alone is not enough

---
