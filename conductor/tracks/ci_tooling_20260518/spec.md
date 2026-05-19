# Spec: Formatting, Linting, and CI

## Overview

Add `fmt`, `lint`, and `test` tasks to the project Taskfile, and wire them into a GitHub
Actions workflow that runs on every push.

## Functional Requirements

### Taskfile Tasks

**`fmt`** — Format all source files in-place:
- Lua files: `stylua .`
- Nix files: `nix fmt`

**`lint`** — Check formatting without modifying files (CI-safe):
- Lua files: `stylua --check .`
- Nix files: `nix fmt -- --check` (nixfmt-rfc-style check mode)

**`test`** — Verify config correctness:
- Static analysis: `luacheck` on all Lua files under `lua/`
- Runtime check: `nvim --headless -u lua/init.lua +qa` to confirm config loads without errors

### GitHub Actions

- Trigger: every push to any branch
- Nix setup: `DeterminateSystems/nix-installer-action`
- Jobs: `lint` and `test` run in parallel
- `luacheck` and `nvim` available via `nix develop`

## Non-Functional Requirements

- CI must pass on a clean checkout with no pre-installed tools (everything via Nix)
- `test` job must exit non-zero if Neovim prints any errors on load

## Acceptance Criteria

- [ ] `task fmt` formats all Lua and Nix files
- [ ] `task lint` exits non-zero when a file is not formatted
- [ ] `task test` exits non-zero when config fails to load or luacheck finds errors
- [ ] GitHub Actions workflow runs lint and test on every push
- [ ] CI passes on a clean checkout

## Out of Scope

- Per-language LSP or DAP testing
- Test coverage metrics (no application logic to measure)
- Windows or macOS CI runners (Linux only for now)
