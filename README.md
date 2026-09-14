# neovim-config

Joshua's Neovim configuration, packaged as a Nix flake.

The flake builds a **self-contained `nvim`**: the plugin set, this repo's Lua
config, prebuilt tree-sitter parsers, and every language server / formatter are
wrapped into one binary with all its runtime tools on `PATH`. Nothing is
symlinked into `~/.config/nvim`, and there is no Docker or Homebrew. It runs on
any machine with Nix.

## Prerequisites

- [Nix](https://nixos.org/download) with flakes enabled
  (`experimental-features = nix-command flakes`)

## Run it

```bash
# Run without installing
nix run github:jnewman/neovim-config

# Install into your nix profile (provides `nvim`)
nix profile install github:jnewman/neovim-config
```

Everything is included — language servers, formatters, tree-sitter parsers, and
tools the config shells out to (`gh`, `curl`, ImageMagick, `mmdc`). There is no
separate setup step and no `:TSInstall`; highlighting works on first launch.

Language servers are also available on their own as `packages.lsp-tools` if you
want them on your PATH outside the editor
(`nix profile install github:jnewman/neovim-config#lsp-tools`).

## Working on the config

From a clone, the `task` commands wrap `nix` (all require Nix with flakes):

```bash
task build    # Build the editor -> ./result/bin/nvim
task run      # Launch the packaged nvim
task install  # nix profile install .#
task check    # nix flake check
task update   # Update all flake inputs (flake.lock)
task fmt      # Format Lua and Nix files
task lint     # Check formatting without modifying
task test     # Run luacheck and actionlint
task ts-test  # Verify parsers load with no compiler on PATH
```

Or invoke Nix directly: `nix build .#`, `nix run .#`, `nix develop`.

## Docs

Plugin reference, keybindings, and config notes: [docs/](docs/README.md)

## License

[BSD 3-Clause](LICENSE) © Josh Newman
