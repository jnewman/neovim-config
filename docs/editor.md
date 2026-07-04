# Editor keymaps

Core, non-plugin keymaps set in [`lua/config/keymaps.lua`](../lua/config/keymaps.lua).
Plugin-specific bindings live on each plugin's page under [plugins/](README.md).

The leader key is `<Space>`.

## General

| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | Normal | Clear search highlight (`nohlsearch`) |
| `<leader>cf` | Normal | Format the current buffer (via conform) |

## Window navigation

Vim's `<C-w>` defaults still work; these are convenience shortcuts.

| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | Normal | Move to the left window |
| `<C-j>` | Normal | Move to the lower window |
| `<C-k>` | Normal | Move to the upper window |
| `<C-l>` | Normal | Move to the right window |

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `<` | Visual | Indent left and keep the selection |
| `>` | Visual | Indent right and keep the selection |
| `J` | Visual | Move the selection down one line |
| `K` | Visual | Move the selection up one line |
| `n` | Normal | Next search result, centred |
| `N` | Normal | Previous search result, centred |

## Bottom terminal

A shell in a horizontal split at the bottom (~30% of editor height). The buffer
is kept alive when hidden, so toggling off and back on resumes the same session.

| Key | Mode | Action |
|-----|------|--------|
| `<C-/>` | Normal / Terminal | Toggle the bottom terminal |
| `<Esc><Esc>` | Terminal | Leave terminal-insert mode (`<C-\><C-n>`) |
