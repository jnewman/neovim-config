# precognition.nvim

## Purpose

Shows the Vim motions available from your current cursor position as virtual-text
hints — the shortcuts you *could* have used. [`tris203/precognition.nvim`](https://github.com/tris203/precognition.nvim)
overlays horizontal hints (`w`, `e`, `b`, `^`, `$`, `f`…) on the current line and
vertical hints (`{`, `}`, line numbers for `G`/relative jumps) in the gutter, so
you can learn faster ways to move without leaving the buffer.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>vp` | Normal | Toggle the motion hints on/off |
| `<leader>vP` | Normal | Peek — show hints until the cursor next moves |

Both live under the `<leader>v` **View** group in which-key.

The plugin also exposes `:Precognition toggle`, `:Precognition peek`,
`:Precognition on`, and `:Precognition off`.

## Config Notes

- `startVisible = false` — hints stay hidden during normal editing and appear only
  when you toggle or peek, keeping the buffer uncluttered.
- Config lives in `lua/config/precognition.lua`, loaded from `lua/init.lua`.
- Packaged from nixpkgs (`vimPlugins.precognition-nvim`) in `modules/plugins.nix`.
