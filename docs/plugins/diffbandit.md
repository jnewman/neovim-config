# diffbandit.nvim

## Purpose

A diff viewer built around a connector gutter. [`CoreyKaylor/diffbandit.nvim`](https://github.com/CoreyKaylor/diffbandit.nvim)
keeps both documents in their original shape and line numbers and draws the
relationship between them in a middle gutter, instead of padding either side.
The right pane is a real editable buffer (LSP, completion, undo, `:w`). Also
does Git review (changed files, commit logs, branch compares), hunk
staging, a commit panel, three-way merges, and folder diffs.

Lives alongside [diffview-nvim](diffview.md) (`<leader>gd`/`gh`/`gH`/`gc`); DiffBandit is under `<leader>gb`.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gbb` | Normal | Open the repo's changed files (`:DiffBanditGit`) |
| `<leader>gbs` | Normal | Staged changes only (`:DiffBanditGit --staged`) |
| `<leader>gbf` | Normal | Diff the current file (`:DiffBanditGitCurrent`) |
| `<leader>gbc` | Normal | Toggle the commit panel (`:DiffBanditCommitPanel`) |
| `<leader>gbl` | Normal | Browse the commit log (`:DiffBanditGitLog`) |
| `<leader>gbm` | Normal | Git workflow menu (`:DiffBanditGitMenu`) |
| `<leader>gbq` | Normal | Close the DiffBandit view (`:DiffBanditClose`) |

Plugin defaults inside a diff view (press `g?` in any DiffBandit window for the live list):

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next / previous hunk |
| `]f` / `[f` | Next / previous changed file in a Git queue |
| `]s` | Snap the other pane to the cursor line |
| `<Space>` | Toggle stage for the active hunk |
| `>>` / `<<` | Apply left → right / right → left |
| `u` | Undo the last DiffBandit hunk action |
| `C` | Open or focus the commit panel |
| `q` | Close the diff session |

## Config Notes

- Not in nixpkgs — built from the `diffbandit-nvim-src` flake input (`nix flake update diffbandit-nvim-src` to bump)
- Uses default `diffbandit.setup()` — no custom options configured
- Smooth bezier connectors render in terminals with Kitty graphics (Ghostty, Kitty) on Neovim 0.12+; elsewhere it falls back to Unicode glyphs
- Other commands: `:DiffBandit <left> <right>`, `:DiffBanditBuffers`, `:DiffBanditFolderDiff`, `:DiffBanditGitCompare`, `:DiffBanditMerge`
