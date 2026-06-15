# Spec: In-Editor Markdown Editing & Rendering

Status: **Draft — awaiting review** · Branch: `feat/jnewman/markdown` · Date: 2026-06-14

## Objective

Add first-class markdown support to this Neovim config: an **in-editor,
rendered "WYSIWYG-style" editing experience** plus the supporting language
toolchain (treesitter, LSP, formatting).

**User:** the config owner, editing `.md` files (notes, docs, READMEs) in
Neovim on the host.

**Success looks like:** opening a `.md` file shows headings, emphasis, lists,
tables, checkboxes, and code blocks rendered inline in the buffer; the raw
markdown for the line under the cursor is revealed so it stays directly
editable; `gd`/`K`/rename/diagnostics work via a markdown LSP; and
format-on-save normalizes the document with prettier.

### Scope decisions (confirmed with owner)

| Decision | Choice |
|---|---|
| In-editor rendering / "WYSIWYG" layer | **markview.nvim** (hybrid mode) |
| Browser preview (markdown-preview.nvim) | **No** — in-editor only, stays in terminal |
| Treesitter parsers | **Yes** — `markdown` + `markdown_inline` |
| Markdown LSP | **Yes** — `marksman` (in Docker `nvim-lsp` container) |
| Prettier formatting for `.md` | **Yes** — reuse existing `prettier_docker` |

### Explicit non-goals

- **No true browser round-trip WYSIWYG.** Editing inside a rendered browser
  view that syncs back to the buffer does not reliably exist for Neovim and is
  out of scope. "WYSIWYG" here means markview's in-buffer hybrid rendering.
- No browser/HTML preview, no mermaid/KaTeX rendering (those need the browser
  layer we're not adding).
- No note-taking framework (no Obsidian/zettelkasten plugins, no wiki links
  beyond what marksman provides).

## Tech Stack

- Neovim (host) + Nix-built static plugin pack (`modules/plugins.nix`)
- nixpkgs pinned to `nixos-unstable` rev `64c08a7` (`flake.lock`)
- LSP/formatters run in the `nvim-lsp` Docker container (`Dockerfile`)
- New plugin: **markview.nvim** (`pkgs.vimPlugins.markview-nvim`) — pure Lua,
  no build step
- New LSP: **marksman** — single static binary from GitHub releases, installed
  into the Docker image (same pattern as `terraform-ls`)
- Parsers: `markdown`, `markdown_inline` via existing `nvim-treesitter`
  `ensure_installed` (runtime compile, like all current parsers)

> Availability note: `nix` is not on the host PATH (builds run via Docker), so
> exact nixpkgs attr names will be confirmed during the build step, not before.
> `markview-nvim` is long-present in nixpkgs `vimPlugins`.

## Commands

```
Rebuild plugin pack (Nix):     task build
Install pack + symlinks:       task install
Rebuild Docker LSP image:      task <docker build task>   # confirm exact name in Taskfile.yml
Lint Lua:                      luacheck lua/ (or: task lint)
Format Lua:                    stylua lua/
```

(Exact Task names verified against `Taskfile.yml` in Task 0.)

## Project Structure

Files this feature touches — follows the existing feature-per-file convention:

```
modules/plugins.nix              → add markview-nvim entry
lua/init.lua                     → require("config.markview")
lua/config/markview.lua          → NEW: markview setup + keymaps (hybrid mode)
lua/config/treesitter.lua        → add "markdown", "markdown_inline"
lua/config/lsp.lua               → add marksman config + enable
lua/config/format.lua            → map markdown → prettier_docker
lua/config/which-key.lua         → add "<leader>m" Markdown group
Dockerfile                       → install marksman binary
docs/plugins/markview.md         → NEW: plugin doc (match existing doc style)
docs/specs/markdown-editing.md   → this spec
```

## Code Style

Match existing `lua/config/*.lua` files: 2-space indent, `stylua.toml`,
double-quoted strings, `require(...).setup({...})`, buffer-local keymaps with
`desc`. Example (the new markview config will look like this):

```lua
require("markview").setup({
  preview = {
    modes = { "n", "no", "c" },   -- render in these modes
    hybrid_modes = { "n" },        -- reveal raw markdown on the cursor line
  },
})

local map = vim.keymap.set
map("n", "<leader>mt", "<cmd>Markview Toggle<cr>", { desc = "Toggle markview" })
map("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", { desc = "Split preview" })
```

LSP additions in `lsp.lua` follow the existing `docker(...)` helper and the
`vim.lsp.config` / `vim.lsp.enable` pattern.

## Testing Strategy

No unit-test framework exists in this repo (it's editor config); verification
is **build + manual smoke test**, consistent with how other plugins/LSPs were
added here.

- **Static:** `luacheck` + `stylua --check` pass on changed Lua.
- **Build:** `task build && task install` succeed; Docker image rebuilds with
  marksman; `nvim --headless "+lua require('markview')" +qa` exits 0.
- **Manual smoke (acceptance):** open `docs/specs/markdown-editing.md` and a
  scratch `.md` with headings, **bold**, a table, `- [ ]` checkbox, fenced code:
  1. Rendering shows styled headings, drawn table, rendered checkbox/emphasis.
  2. Moving the cursor onto a styled line reveals its raw markdown (hybrid).
  3. `:Markview Toggle` turns rendering off/on.
  4. `marksman` attaches (`:LspInfo`); `K`/`gd` on a heading/link work.
  5. `:w` runs prettier and reformats without errors.
  6. `:checkhealth` and startup show no markview/treesitter errors.

## Boundaries

- **Always:** run `stylua` + `luacheck` before committing; keep one
  feature-per-file; add a `desc` to every keymap; follow the existing
  `docker()` LSP and `ensure_installed` conventions.
- **Ask first:** changing the nixpkgs pin; adding any plugin beyond
  markview-nvim; adding a second markdown plugin; changing global options that
  affect non-markdown filetypes (`conceallevel` is set buffer-local for md
  only).
- **Never:** introduce the browser-preview layer or extra dependencies not in
  this spec; commit without a successful `task build`; pin marksman to an
  unverified/nonexistent release tag.

## Success Criteria

1. `.md` files render inline (headings, emphasis, lists, tables, checkboxes,
   code blocks) via markview with hybrid mode revealing the cursor line.
2. `:Markview Toggle` and a `<leader>m…` keymap group exist and work.
3. `markdown` + `markdown_inline` parsers installed; no treesitter errors.
4. `marksman` runs in the Docker container and attaches to `.md` buffers; LSP
   keymaps (`gd`, `K`, rename, diagnostics) function.
5. Format-on-save runs prettier for markdown without error.
6. `task build && task install` succeed cleanly; headless nvim load is error-free.
7. A `docs/plugins/markview.md` doc exists matching the repo's doc style.

## Open Questions

1. **Hybrid scope:** render in normal+command modes and reveal raw only in the
   line under the cursor (proposed), or a simpler "render in normal mode, full
   raw in insert mode" toggle? *Proposed: full hybrid.*
2. **`conceallevel`:** markview wants `conceallevel=2/3`. Set buffer-local for
   markdown only (proposed) — confirm you don't want it global.
3. **marksman version:** pin a specific dated release tag (e.g. a recent
   `YYYY-MM-DD`) vs. track latest at image-build time. *Proposed: pin a
   verified recent tag for reproducibility.*
```
