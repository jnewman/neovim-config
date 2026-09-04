# nvim-colorizer.lua

## Purpose

Inline color previews. colorizer scans the buffer for color literals and paints
each one with the color it names, so a palette in a CSS, Lua, or theme file is
readable at a glance. It attaches to every filetype automatically.

Recognized: `#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb(...)`, and `hsl(...)`.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>vC` | Normal | Toggle color previews for the current buffer |

The `<leader>v` group is registered as "View" in which-key.

## Config Notes

- Uses the maintained [catgoose fork](https://github.com/catgoose/nvim-colorizer.lua);
  `pkgs.vimPlugins.nvim-colorizer-lua` in nixpkgs already tracks it, not
  norcalli's unmaintained original.
- `names = false` — CSS color names (`red`, `tan`, `gold`) collide with ordinary
  English words and identifiers, so they'd highlight far more prose than actual
  colors.
- `mode = "background"` paints the literal's own background. `"foreground"`
  tints the text instead; `"virtualtext"` appends a colored marker.
- Requires `termguicolors`, set in `lua/config/options.lua`.
- Other commands: `:ColorizerAttachToBuffer`, `:ColorizerDetachFromBuffer`,
  `:ColorizerReloadAllBuffers`.
