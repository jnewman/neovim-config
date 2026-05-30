# Spec: Multi-Language DAP Debugger Support

## Overview

Add Debug Adapter Protocol (DAP) debugger integration to the Neovim config for all
12 supported languages. Two new Nix plugins are added: `nvim-dap` (core DAP client)
and `nvim-dap-ui` (panels for variables, call stack, breakpoints, console). Debug
adapters are installed inside the existing `nvim-lsp` Docker container and accessed
via `docker exec`, consistent with the existing LSP/formatter architecture.

## Functional Requirements

### 1. Plugins
- `nvim-dap` added to `modules/plugins.nix`
- `nvim-dap-ui` added to `modules/plugins.nix`
- New config file `lua/config/dap.lua` required and loaded from `lua/init.lua`

### 2. Debug Adapters in Container
- All available adapters installed at image build time in the `nvim-lsp` Dockerfile
- Adapters accessed via `docker exec -i nvim-lsp <adapter-binary>`
- 10 of 12 languages have DAP adapters; XML and HCL are explicitly out of scope
  (no adapter exists)

### 3. Per-Language Adapter Configuration
Each supported language gets an nvim-dap adapter entry + at least one launch
configuration in `lua/config/dap.lua`.

| Language   | Adapter                | Install (container)                                  | Notes                          |
|------------|------------------------|------------------------------------------------------|--------------------------------|
| Python     | debugpy                | pip install debugpy                                  | `python -m debugpy --listen`   |
| Rust       | codelldb               | GitHub release binary                                | Shared with C                  |
| TypeScript | vscode-js-debug        | npm (vscode-js-debug)                                | Node.js required               |
| Go         | delve (dlv)            | go install github.com/go-delve/delve/cmd/dlv         | `dlv dap` mode                 |
| Scala      | metals (built-in)      | Already present (LSP)                                | metals serves DAP directly     |
| Haskell    | haskell-debug-adapter  | cabal install                                        | Experimental; best-effort      |
| Ruby       | rdbg (debug gem)       | gem install debug                                    | Ruby 3.1+ native DAP           |
| C          | codelldb               | Shared with Rust                                     |                                |
| Bash       | bash-debug             | npm install bash-debug                               | Limited; best-effort           |
| HTML       | vscode-js-debug        | Shared with TypeScript                               | Via Chrome DevTools Protocol   |
| XML        | (none)                 | N/A — no DAP adapter exists                          | Out of scope                   |
| HCL        | (none)                 | N/A — no DAP adapter exists                          | Out of scope                   |

### 4. nvim-dap-ui
- Auto-opens on DAP session start, closes on session end
- Configured with standard layouts: variables, scopes, stacks, breakpoints, console

### 5. Keymaps
Consistent keymap set in `lua/config/dap.lua`:
- `<leader>db` — toggle breakpoint
- `<leader>dc` — continue / start
- `<F5>` — continue / start
- `<F10>` — step over
- `<F11>` — step into
- `<F12>` — step out
- `<leader>du` — toggle nvim-dap-ui

### 6. Dockerfile Updates
- codelldb binary downloaded and extracted
- debugpy, vscode-js-debug, delve, haskell-debug-adapter, rdbg, bash-debug added

### 7. Documentation
- `conductor/tech-stack.md` updated with DAP adapter table

## Non-Functional Requirements
- No new host tools required (all adapters in Docker)
- `docker exec` adapter spawn overhead < 1 second (one-time per session)
- nvim-dap-ui opens automatically without manual intervention

## Acceptance Criteria
- Setting a breakpoint and hitting `<leader>dc` in a Python/Go/Rust/TypeScript/C file
  starts a debug session and stops at the breakpoint
- nvim-dap-ui panels open automatically showing variables and call stack
- All keymaps work correctly
- XML and HCL have a clear comment in `dap.lua` explaining no adapter is available
- Dockerfile builds successfully with all new adapters present

## Out of Scope
- XML and HCL debugger support (no DAP adapter available)
- Remote debugging over SSH
- Conditional breakpoints UI (nvim-dap supports it but no dedicated keymap needed now)
- Windows host support
