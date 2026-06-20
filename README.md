# neovim-config

Joshua's Neovim configuration.

The build runs on Nix. **On a nix host** (any machine with the `nix` executable on
PATH) everything runs Nix directly and Docker is never used — plugins build natively
and language servers/formatters come from the flake's `lsp-tools` package. **On any
other host** the same Nix work runs inside the `nixos/nix` container and language
tooling runs inside the `nvim-lsp` container; Neovim itself runs on the host via
Homebrew. The `task` commands detect which host you're on automatically.

## Prerequisites

- [Task](https://taskfile.dev) (go-task)
- On a nix host: [Nix](https://nixos.org/download) with flakes available
- On a non-nix host: [Docker Desktop](https://www.docker.com/products/docker-desktop/) and [Homebrew](https://brew.sh)

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

Builds the plugin pack, wires config symlinks, and (on a non-nix host) installs Homebrew dependencies. Safe to re-run. On first launch run `:TSInstall` to compile tree-sitter parsers.

## Language servers

```bash
task lsp-build    # nix: build flake lsp-tools | otherwise: build nvim-lsp Docker image
task lsp-install  # nix: install lsp-tools into your nix profile | otherwise: register the auto-start container
```

On a nix host the editor invokes language servers and formatters directly off PATH (from `lsp-tools`); everywhere else it runs them via `docker exec` into the `nvim-lsp` container.

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

## License

[BSD 3-Clause](LICENSE) © Josh Newman
