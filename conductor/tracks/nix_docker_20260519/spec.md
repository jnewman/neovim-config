# Spec: Migrate Nix Build to Docker

## Overview

Replace host-installed Nix with the official `nixos/nix` Docker image for all build
operations. Neovim continues to run on the host; its configuration, plugins, LSP servers,
formatters, and debuggers are built inside Docker and copied to host paths via `docker cp`.
This eliminates any Nix installation from the developer's machine.

The existing `flake.nix` / home-manager structure is replaced with a direct `nix build`
approach that produces a single store-path artifact — easier to copy out of Docker and
deploy to host paths.

## Functional Requirements

1. **Remove host Nix** — Uninstall Nix from the host; no Nix daemon, no `/nix` store on host.
2. **Restructure flake.nix** — Replace home-manager config with a `packages.default` (or
   `packages.nvim-config`) output that produces a single path containing everything nvim
   needs (init.lua, plugin store paths, wrapper script, etc.).
3. **`task build`** — Launches the official `nixos/nix` Docker image, mounts the repo,
   runs `nix build`, and produces a result artifact inside the container.
4. **`task install`** — Uses `docker cp` to copy build outputs from the container into
   the correct host paths (`~/.config/nvim`, `~/.local/share/nvim`, binary wrappers, etc.).
5. **CI update** — GitHub Actions workflow updated to use the official Nix Docker image
   instead of `DeterminateSystems/nix-installer-action`.

## Non-Functional Requirements

- Reproducible: same `flake.lock` → same outputs, regardless of host OS state.
- Docker layer caching used to keep rebuild times reasonable.
- Host stays clean: no `/nix` directory, no Nix daemon process.

## Acceptance Criteria

- [ ] `which nix` on the host returns nothing (Nix fully removed).
- [ ] `task build` completes successfully; build artifacts exist inside the container.
- [ ] `task install` copies artifacts to the correct host paths without error.
- [ ] `nvim` launches on the host with plugins, LSPs, formatters, and debuggers working.
- [ ] `flake.nix` no longer depends on home-manager; exposes a buildable `packages` output.
- [ ] CI passes on GitHub Actions using the new Docker-based workflow.

## Out of Scope

- Switching to a different package manager (lazy.nvim + Mason) — Nix is retained, just containerized.
- Automated rebuilds via git hooks or watch mode — manual `task build` only.
- Publishing the Docker image to a registry.
- Multi-machine / remote deployment of the built config.
