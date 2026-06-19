# Mermaid preview (image.nvim + mermaid-cli)

## Purpose

Inline preview of [mermaid](https://mermaid.js.org/) diagrams without leaving
the editor. The mermaid CLI (`mmdc`) renders the diagram to a PNG and
[image.nvim](https://github.com/3rd/image.nvim) draws it in a split using the
kitty graphics protocol. It renders:

- the **whole buffer** for `.mermaid` / `.mmd` files, and
- the ` ```mermaid ` **fenced block under the cursor** in markdown files.

Rendering is **on demand** (`<leader>mp`), not live — re-run it to refresh after
edits. This is the inline-image counterpart to [markview](markview.md)'s text
rendering; it intentionally supersedes the "no mermaid (needs a browser)"
non-goal in the markdown spec, since image.nvim renders in-terminal with no
browser round-trip.

## Requirements

- A graphics-capable terminal: **kitty**, **ghostty**, or **wezterm**. In any
  other terminal the command runs but no image appears.
- `mmdc` (mermaid-cli) and ImageMagick on PATH — shipped via `lsp-tools.nix`
  (nix hosts, `task lsp-install`) and the `Brewfile` (non-nix hosts).

## Keybindings

| Key | Action |
|-----|--------|
| `<leader>mp` | Render the mermaid diagram under the cursor / the whole `.mermaid` file |
| `<leader>mx` | Close the mermaid preview split |

Also available as the `:MermaidPreview` and `:MermaidClear` commands. The
`<leader>m` group is registered as "Markdown/Mermaid" in which-key.

## Config Notes

- `vim.filetype.add` maps `.mermaid` and `.mmd` to the `mermaid` filetype so
  whole-buffer rendering can key off it.
- image.nvim uses `backend = "kitty"` and `processor = "magick_cli"`, so it
  drives ImageMagick's CLI rather than the `magick` luarock — no luarocks
  install needed. Its markdown/neorg auto-render integrations are disabled; we
  render only on command.
- `mmdc` is invoked with `-t dark -b transparent -s 3` — a dark theme with a
  transparent background and 3× super-sampling for a sharp image on a dark
  terminal. Tune these in `lua/config/mermaid.lua`.
- The preview reuses a single vertical split; the image is fit to the split's
  width with aspect ratio preserved. `<leader>mx` clears the image and closes
  the split.
