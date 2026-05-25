# Spec: Make Config More Reusable

## Overview

Improve the portability and onboarding experience of this Neovim config by:
1. Adding an idempotent `task setup` that bootstraps everything from scratch
2. Replacing hardcoded paths with `$HOME`-relative references throughout
3. Restructuring docs — a minimal README that links to a new `docs/` directory with per-plugin pages

## Functional Requirements

### 1. Idempotent Setup Task (`task setup`)
- Provide install one-liners for go-task on Mac (`brew install go-task`) and Linux (e.g., `sh -c "$(curl ...)"`)
- `task setup` runs the full bootstrap in order:
  1. `brew bundle` — install Homebrew dependencies (idempotent by default)
  2. Build plugin pack via Docker (`task build`) — skip if pack already up to date
  3. Symlink `lua/` configs into `~/.config/nvim/` (`task install`) — skip if symlinks already correct
- Re-running `task setup` must be safe: no duplicate symlinks, no redundant builds, no errors if already installed

### 2. Use `$HOME` Throughout
- Audit all Lua files, Taskfile, and shell scripts for hardcoded absolute paths (e.g., `/Users/joshua/`, `~`)
- Replace with `$HOME`-relative equivalents (`$HOME/.config/nvim/`, `$HOME/.local/share/nvim/`, etc.)
- Lua files: use `vim.fn.expand('$HOME/...')` or `vim.env.HOME` where paths are constructed programmatically

### 3. Minimal README
- README becomes: 1-2 sentence description, prerequisites list, go-task install one-liners, `task setup` quickstart
- All existing detail moves to or is replaced by `docs/`

### 4. `docs/` Directory with Per-Plugin Pages
- Create `docs/plugins/` with one `.md` file per plugin
- Each page contains:
  - **Purpose**: 1-2 sentences on what it does and why it's included
  - **Keybindings**: all configured keymaps for this plugin
  - **Config notes**: any non-obvious configuration decisions
- Create `docs/README.md` as an index linking to each plugin doc and other doc files

## Non-Functional Requirements

- All Taskfile tasks must remain composable (individual tasks still runnable standalone)
- No functional behavior changes — this is a refactor/chore track

## Acceptance Criteria

- [ ] `task setup` runs end-to-end on a clean machine and produces a working Neovim install
- [ ] Re-running `task setup` on an already-set-up machine exits cleanly with no errors or side effects
- [ ] No hardcoded absolute paths remain in Lua files, Taskfile, or scripts
- [ ] README is ≤ 50 lines
- [ ] `docs/plugins/` exists with one page per plugin covering purpose, keybindings, and config notes
- [ ] `docs/README.md` index links to all doc pages

## Out of Scope

- Adding new plugins
- Changing existing keybindings or plugin behavior
- Windows support
- Automated testing of the setup task itself
