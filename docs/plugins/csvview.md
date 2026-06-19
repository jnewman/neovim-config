# csvview.nvim

## Purpose

A CSV/TSV table viewer. It parses delimited files and overlays aligned,
bordered columns on top of the raw buffer, so a comma-soup file reads like a
table while the underlying text stays fully editable. The view enables
automatically when a `.csv` or `.tsv` file is opened.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>vc` | Normal | Toggle the CSV table view |
| `if` / `af` | Operator/Visual | Select the inner/outer field (cell) under the cursor |
| `<Tab>` / `<S-Tab>` | Normal/Visual | Jump to the next/previous cell (view active) |
| `<Enter>` / `<S-Enter>` | Normal/Visual | Jump to the next/previous row (view active) |

The `<leader>v` group is registered as "View" in which-key.

## Config Notes

- Auto-enables on `csv` and `tsv` filetypes via a `FileType` autocmd; `<leader>vc`
  (`:CsvViewToggle`) turns it off/on for the current buffer.
- `view.display_mode = "border"` draws real column borders; `spacing = 2` pads
  cells. Use `"highlight"` instead for a lighter, tint-only view.
- `parser.comments = { "#", "//" }` — lines starting with these are skipped, not
  treated as table rows.
- The view is an overlay only; the buffer's bytes are unchanged, so edits and
  `:w` behave normally.
