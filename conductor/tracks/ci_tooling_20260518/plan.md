# Plan: Formatting, Linting, and CI

## Phase 1: Dev Environment & Config

- [ ] Task 1: Add `devShell` to `flake.nix` exposing `luacheck` and `neovim` for use by tasks and CI
- [ ] Task 2: Create `.luacheckrc` configuring Neovim globals (`vim`, `require`, etc.)
- [ ] Task 3: Conductor - User Manual Verification 'Dev Environment & Config' (Protocol in workflow.md)

## Phase 2: Taskfile Tasks

- [ ] Task 1: Add `fmt` task — `stylua .` + `nix fmt`
- [ ] Task 2: Add `lint` task — `stylua --check .` + `nix fmt -- --check`
- [ ] Task 3: Add `test` task — `luacheck lua/` + `nvim --headless -u lua/init.lua +qa`
- [ ] Task 4: Conductor - User Manual Verification 'Taskfile Tasks' (Protocol in workflow.md)

## Phase 3: GitHub Actions CI

- [ ] Task 1: Create `.github/workflows/ci.yml` — `lint` and `test` jobs in parallel, DeterminateSystems/nix-installer-action, runs on every push
- [ ] Task 2: Conductor - User Manual Verification 'GitHub Actions CI' (Protocol in workflow.md)
