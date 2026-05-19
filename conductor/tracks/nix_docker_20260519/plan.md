# Implementation Plan: Migrate Nix Build to Docker

## Phase 1: Restructure flake.nix

- [ ] Task 1: Audit current neovim modules
  - [ ] Read modules/neovim.nix and modules/nix.nix
  - [ ] Catalog what home-manager manages: plugins, LSP servers, config files, wrapped binary, PATH entries
  - [ ] Identify target output layout (what paths nvim needs on the host)

- [ ] Task 2: Design packages.nvim-config derivation
  - [ ] Choose approach: `pkgs.wrapNeovim` producing a wrapped binary, or `pkgs.buildEnv` / `mkDerivation` producing a copyable config directory
  - [ ] Define output layout: what lands in ~/.config/nvim/, ~/.local/share/nvim/, ~/bin/, etc.

- [ ] Task 3: Rewrite flake.nix
  - [ ] Remove home-manager from inputs and outputs
  - [ ] Add `packages.${system}.nvim-config` (and `.default`) using the new derivation
  - [ ] Keep devShells.default (stylua, nixfmt, luacheck, neovim) for lint/test tooling
  - [ ] Remove apps.rebuild (superseded by task build in Phase 2)

- [ ] Task 4: Verify nix build inside Docker
  - [ ] Run `docker run --rm -v $(pwd):/repo -w /repo nixos/nix nix build .#nvim-config --no-sandbox`
  - [ ] Confirm result resolves correctly; output structure matches the design from Task 2

- [ ] Task: Conductor - User Manual Verification 'Phase 1: Restructure flake.nix' (Protocol in workflow.md)

## Phase 2: Docker Build + Taskfile Integration

- [ ] Task 1: Add task build
  - [ ] Create named container `nvim-build`, bind-mount repo, run `nix build .#nvim-config --no-sandbox`
  - [ ] Copy dereferenced result to a staging path inside the container (e.g. /tmp/nvim-result/)

- [ ] Task 2: Add task install
  - [ ] `docker cp nvim-build:/tmp/nvim-result/. <host-target-path>`
  - [ ] Remove the build container after copy

- [ ] Task 3: Update existing Taskfile tasks
  - [ ] Replace task update — run `nix flake update` inside Docker
  - [ ] Replace task fmt — run `nix develop --command stylua + nixfmt` inside Docker
  - [ ] Replace task lint — run `nix develop --command stylua --check + nixfmt --check` inside Docker
  - [ ] Replace task test — run `nix develop --command luacheck + nvim headless` inside Docker
  - [ ] Remove task rebuild (superseded by build + install)

- [ ] Task 4: End-to-end verification
  - [ ] Run `task build` — confirm build completes
  - [ ] Run `task install` — confirm files land at correct host paths
  - [ ] Launch nvim on host — confirm plugins, LSPs, formatters, debuggers load correctly

- [ ] Task: Conductor - User Manual Verification 'Phase 2: Docker Build + Taskfile Integration' (Protocol in workflow.md)

## Phase 3: CI Update

- [ ] Task 1: Update GitHub Actions workflow
  - [ ] Replace `DeterminateSystems/nix-installer-action` with official `nixos/nix` Docker container approach (use nixos/nix image as job container, or docker-in-docker)
  - [ ] Update lint and test steps to invoke tooling inside the container

- [ ] Task 2: Push branch and verify CI
  - [ ] Confirm both lint and test jobs pass on GitHub Actions
  - [ ] Fix any failures

- [ ] Task: Conductor - User Manual Verification 'Phase 3: CI Update' (Protocol in workflow.md)

## Phase 4: Cleanup & Documentation

- [ ] Task 1: Host Nix removal guide
  - [ ] Add a `task uninstall-host-nix` with platform-appropriate instructions, or add a README section with manual uninstall steps
  - [ ] Verify nvim still works after host Nix is removed

- [ ] Task 2: Update project documentation
  - [ ] Update README.md — prerequisites: Docker only, no Nix required on host
  - [ ] Update conductor/tech-stack.md — replace home-manager section with Docker-wrapped Nix
  - [ ] Update conductor/product.md — adjust description of the managed environment

- [ ] Task: Conductor - User Manual Verification 'Phase 4: Cleanup & Documentation' (Protocol in workflow.md)
