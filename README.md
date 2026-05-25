# neovim-config

Joshua's Neovim configuration. Plugins are built inside Docker using Nix; Neovim and language tooling run on the host via Homebrew.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Homebrew](https://brew.sh)
- [Task](https://taskfile.dev) (go-task)

**Install Task:**

```bash
# macOS
brew install go-task

# Linux
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
```

## Setup

```bash
task setup
```

Installs Homebrew dependencies, builds the plugin pack inside Docker, and wires config symlinks. Safe to re-run. On first launch run `:TSInstall` to compile tree-sitter parsers.

## Daily workflow

```bash
task build    # Rebuild plugin pack (after changes to modules/plugins.nix)
task install  # Re-install pack and refresh symlinks
task update   # Update all flake inputs
task fmt      # Format Lua and Nix files
task lint     # Check formatting without modifying
task test     # Run luacheck
```

## Docs

Plugin reference, keybindings, and config notes: [docs/](docs/README.md)
