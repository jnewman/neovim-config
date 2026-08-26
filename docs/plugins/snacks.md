# snacks.nvim

## Purpose

Persistent scratch buffers. [`folke/snacks.nvim`](https://github.com/folke/snacks.nvim)
is a suite of small independent modules; this config enables **only `scratch`**.

A scratch buffer is a floating window backed by a real file under
`stdpath("data")/scratch`, so notes survive restarts. The file is keyed by
name + filetype + cwd + git branch + count, meaning each project — and each
branch within it — gets its own scratch buffer automatically.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>.` | Normal | Toggle the scratch buffer for the current cwd/branch |
| `<leader>S` | Normal | Pick from all existing scratch buffers |

Both are leaf keys — no which-key group. Prefixing with a count opens a
distinct buffer, so `2<leader>.` is a second scratch pad for the same project.

Inside the scratch window:

- `q` or `<Esc>` — close (the buffer is written automatically on hide)
- `<CR>` — in a `lua` scratch buffer, source the buffer and show the result

## Config Notes

- Filetype defaults to the current buffer's filetype, falling back to
  `markdown` — so markview.nvim renders a markdown scratch pad as usual.
- `autowrite` is on by default: hiding the window saves the file.
- Every other snacks module (`notifier`, `picker`, `dashboard`, `indent`,
  `image`, `explorer`, …) is left **disabled**. noice.nvim + nvim-notify,
  telescope, indent-blankline, and image.nvim already fill those roles here,
  and enabling the snacks equivalents would mean two plugins competing for
  the same UI. Modules only activate when passed to `setup()`, so nothing
  else is loaded.
- Config lives in `lua/config/snacks.lua`, loaded from `lua/init.lua`.
- Packaged from nixpkgs (`vimPlugins.snacks-nvim`) in `modules/plugins.nix`.

Unrelated: kulala's `<leader>Rb` "scratchpad" is a throwaway `.http` request
buffer, not a general-purpose notes pad. See [kulala.nvim](kulala.md).
