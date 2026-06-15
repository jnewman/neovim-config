# markview.nvim

## Purpose

In-editor markdown rendering. Renders markdown inline in the buffer — headings,
emphasis, lists, tables, checkboxes, and code blocks — giving a "WYSIWYG-style"
editing experience without leaving the terminal. In hybrid mode the raw
markdown for the line under the cursor is revealed, so the document stays
directly editable while it looks rendered.

This is the in-editor layer only; there is no browser preview (by design — true
browser round-trip WYSIWYG does not exist reliably for Neovim).

## Keybindings

| Key | Action |
|-----|--------|
| `<leader>mt` | Toggle markview rendering on/off |
| `<leader>ms` | Toggle split preview |
| `<leader>mh` | Toggle hybrid mode (raw markdown on the cursor line) |

The `<leader>m` group is registered as "Markdown" in which-key.

## Config Notes

- `preview.modes = { "n", "no", "c" }` — renders while navigating and in command
  mode; raw text is shown while inserting so typing is never obscured.
- `preview.hybrid_modes = { "n" }` — reveals raw markdown on the cursor line in
  normal mode, the core of the hybrid editing experience.
- markview manages `conceallevel` for attached markdown buffers only, so it
  never affects other filetypes.
- Requires the `markdown` and `markdown_inline` treesitter parsers (declared in
  `lua/config/treesitter.lua`).
- Markdown LSP (`marksman`) and prettier formatting are configured separately in
  `lua/config/lsp.lua` and `lua/config/format.lua`.
