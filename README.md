# neovim-config

Joshua's Neovim configuration, managed with Nix flakes and home-manager.

## Requirements

- [Nix](https://nixos.org/download) with flakes and `nix-command` enabled
- [home-manager](https://github.com/nix-community/home-manager)

## Apply the configuration

```bash
# First time or after any change
nix run home-manager -- switch --flake .#default
```

This installs Neovim (aliased as `vim` and `vi`) and links all Lua config files into `~/.config/nvim/`.

## Development shell

For formatting tools (stylua, nixfmt):

```bash
nix develop
```

| Tool | Purpose |
|------|---------|
| `stylua` | Format Lua files |
| `nixfmt-rfc-style` | Format Nix files |

## Project layout

```
flake.nix           # Flake entry point — inputs, home config, dev shell
modules/
  neovim.nix        # home-manager neovim module (plugins, extraLuaConfig)
  nix.nix           # Nix settings (enables flakes + nix-command)
lua/
  init.lua          # Entry point — loads all config modules
  config/
    options.lua     # Editor options (line numbers, tabs, clipboard, …)
    keymaps.lua     # Key mappings
    autocmds.lua    # Auto-commands
    colorscheme.lua # Catppuccin theme setup and light/dark toggle
stylua.toml         # Lua formatter config
```

## Plugins

| Plugin | Role |
|--------|------|
| [catppuccin-nvim](https://github.com/catppuccin/nvim) | Colorscheme (Latte / Mocha) |

## Key mappings

| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | Normal | Clear search highlight |
| `<C-h/j/k/l>` | Normal | Navigate windows |
| `<` / `>` | Visual | Indent and reselect |
| `J` / `K` | Visual | Move selection down / up |
| `n` / `N` | Normal | Next/prev search result (centred) |
| `<leader>tt` | Normal | Toggle light / dark theme |

## Supported systems

The flake supports `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, and `aarch64-darwin`. The default `homeConfigurations.default` targets `aarch64-darwin` (Apple Silicon). Adjust the `system` value in `flake.nix` if needed.
