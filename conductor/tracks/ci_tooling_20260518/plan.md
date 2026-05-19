# Plan: Formatting, Linting, and CI

## Phase 1: Dev Environment & Config

- [x] Task 1: Add `devShell` to `flake.nix` exposing `luacheck` and `neovim` for use by tasks and CI <!-- 2890c54 -->
- [x] Task 2: Create `.luacheckrc` configuring Neovim globals (`vim`, `require`, etc.) <!-- 2890c54 -->
- [x] Task 3: Conductor - User Manual Verification 'Dev Environment & Config' (Protocol in workflow.md)

## Phase 2: Taskfile Tasks

- [x] Task 1: Add `fmt` task — `stylua .` + `nix fmt`
- [x] Task 2: Add `lint` task — `stylua --check .` + `nix fmt -- --check`
- [x] Task 3: Add `test` task — `luacheck lua/` + `nvim --headless -u lua/init.lua +qa`
- [x] Task 4: Conductor - User Manual Verification 'Taskfile Tasks' (Protocol in workflow.md)

## Phase 3: GitHub Actions CI

- [x] Task 1: Create `.github/workflows/ci.yml` — `lint` and `test` jobs in parallel, DeterminateSystems/nix-installer-action, runs on every push
- [ ] Task 2: Conductor - User Manual Verification 'GitHub Actions CI' (Protocol in workflow.md)
