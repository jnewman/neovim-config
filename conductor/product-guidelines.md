# Product Guidelines: neovim-config

## Design Philosophy

Opinionated by default. The config ships with strong, considered defaults so it works well
out of the box without requiring per-machine tuning. Users adopt the config as-is; they do
not configure it.

## Keybindings

Stay close to stock Neovim and Vim conventions. Remappings are only introduced where they
fix a genuine ergonomic problem or wire up a new feature that has no natural default.
No wholesale remapping of core motions or modes.

## Visual & UI

- **Status line** — Rich, informative: shows git branch/status, LSP status, active
  diagnostics counts, and file metadata.
- **Colorscheme** — A single consistent theme applied to all UI surfaces (editor, status
  line, file tree, telescope, etc.). Both a light and dark variant are supported and
  switchable.
- No unnecessary UI decoration — chrome that does not carry information is removed.

## Plugin Selection Criteria

A plugin is included only if it meets **all** of:
1. Actively maintained with a responsive upstream (issues addressed, not abandoned)
2. Written in Lua (no legacy Vimscript plugins where a Lua alternative exists)
3. Available as a Nix package (in nixpkgs or a supported overlay)

## Update Policy

Eager updates. Flake inputs are kept at latest; breakage is fixed promptly rather than
avoided by pinning. The goal is to stay current with the Neovim and plugin ecosystems,
not to defer problems.
