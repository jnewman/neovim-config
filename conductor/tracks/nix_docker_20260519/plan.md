# Implementation Plan: Migrate Nix Build to Docker

*Last Revised: 2026-05-19 (Revision 1 — updated for plugin-pack approach)*

## Phase 1: Restructure flake.nix

- [x] Task 1: Audit current neovim modules
  - [x] Read modules/neovim.nix and modules/nix.nix
  - [x] Catalog what home-manager manages: plugins, LSP servers, config files, wrapped binary, PATH entries
  - [x] Identify target output layout (what paths nvim needs on the host)

- [ ] Task 2: Design packages.nvim-plugin-pack derivation
  - [ ] Design a `runCommand` derivation that `cp -rL`s each plugin store path into `$out/pack/nix/start/<plugin-name>/`
  - [ ] Define install layout: plugin pack → `~/.local/share/nvim/site/`, Lua config → `~/.config/nvim/lua/` symlink, init.lua → `~/.config/nvim/init.lua`
  - [ ] List Homebrew dependencies for Brewfile: neovim, lua-language-server, nixd, stylua, nixfmt, gh

- [ ] Task 3: Rewrite flake.nix
  - [ ] Remove home-manager from inputs and outputs
  - [ ] Remove modules/nix.nix (home.username, home.homeDirectory no longer needed)
  - [ ] Rewrite modules/neovim.nix as a plain Nix expression producing the plugin pack derivation (no programs.neovim, no xdg.configFile)
  - [ ] Add `packages.${system}.nvim-plugin-pack` (and `.default`) in flake.nix
  - [ ] Keep devShells.default (stylua, nixfmt, luacheck, neovim) for lint/test CI tooling
  - [ ] Add `Brewfile` listing: neovim, lua-language-server, lua-language-server, nixd, stylua, nixfmt, gh

- [ ] Task 4: Verify nix build inside Docker
  - [ ] Run `docker run --rm -v $(pwd):/repo -w /repo nixos/nix nix build .#nvim-plugin-pack --no-sandbox`
  - [ ] Confirm `result/pack/nix/start/` exists with all plugin directories
  - [ ] Confirm plugin directories contain plain files (no dangling store symlinks)

- [ ] Task: Conductor - User Manual Verification 'Phase 1: Restructure flake.nix' (Protocol in workflow.md)

## Phase 2: Docker Build + Taskfile Integration

- [ ] Task 1: Add task build
  - [ ] Create named container `nvim-build`, bind-mount repo, run `nix build .#nvim-plugin-pack --no-sandbox`
  - [ ] `cp -rL ./result/. /tmp/nvim-pack/` inside container to dereference store symlinks

- [ ] Task 2: Add task install
  - [ ] `docker cp nvim-build:/tmp/nvim-pack/pack ~/.local/share/nvim/site/`
  - [ ] Symlink `~/.config/nvim/lua` → `<repo>/lua/` (idempotent)
  - [ ] Copy or symlink `~/.config/nvim/init.lua` → `<repo>/lua/init.lua`
  - [ ] Remove build container after install

- [ ] Task 3: Update existing Taskfile tasks
  - [ ] Replace task update — run `nix flake update` inside Docker (ephemeral container)
  - [ ] Replace task fmt — run `nix develop --command stylua + nixfmt` inside Docker
  - [ ] Replace task lint — run `nix develop --command stylua --check + nixfmt --check` inside Docker
  - [ ] Replace task test — run `nix develop --command luacheck + nvim headless` inside Docker
  - [ ] Remove task rebuild (superseded by build + install)

- [ ] Task 4: End-to-end verification
  - [ ] Run `task build` — confirm build completes
  - [ ] Run `task install` — confirm pack lands at `~/.local/share/nvim/site/pack/nix/start/`
  - [ ] Launch host nvim — confirm plugins, LSPs (via Homebrew), formatters load correctly

- [ ] Task: Conductor - User Manual Verification 'Phase 2: Docker Build + Taskfile Integration' (Protocol in workflow.md)

## Phase 3: CI Update

- [ ] Task 1: Update GitHub Actions workflow
  - [ ] Replace `DeterminateSystems/nix-installer-action` with official `nixos/nix` Docker container approach
  - [ ] Update lint and test steps to invoke tooling inside the container

- [ ] Task 2: Push branch and verify CI
  - [ ] Confirm both lint and test jobs pass on GitHub Actions
  - [ ] Fix any failures

- [ ] Task: Conductor - User Manual Verification 'Phase 3: CI Update' (Protocol in workflow.md)

## Phase 4: Cleanup & Documentation

- [ ] Task 1: Host Nix removal guide
  - [ ] Add a `task uninstall-host-nix` with macOS-appropriate instructions (official Nix uninstaller + nix-darwin if applicable)
  - [ ] Add `task brew-install` that runs `brew bundle` to install all Brewfile dependencies

- [ ] Task 2: Update project documentation
  - [ ] Update README.md — prerequisites: Docker + Homebrew only, no Nix on host
  - [ ] Update conductor/tech-stack.md — replace home-manager section with Docker-built plugin pack + Homebrew tools
  - [ ] Update conductor/product.md — adjust managed environment description

- [ ] Task: Conductor - User Manual Verification 'Phase 4: Cleanup & Documentation' (Protocol in workflow.md)
