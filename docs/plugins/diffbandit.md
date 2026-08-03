# diffbandit.nvim

## Purpose

A side-by-side diff viewer that shows the source and destination documents with
their original formatting intact, using a connector gutter down the middle to map
changes between the two sides without distorting either.
[`CoreyKaylor/diffbandit.nvim`](https://github.com/CoreyKaylor/diffbandit.nvim)
complements [diffview-nvim](diffview.md): diffview gives a unified/inline diff and
git-history browser, while diffbandit focuses on a true two-pane comparison and
adds a commit-staging panel.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gbg` | Normal | Diff the repository's changes (`:DiffBanditGit`) |
| `<leader>gbf` | Normal | Diff the current file against git (`:DiffBanditGitCurrent`) |
| `<leader>gbc` | Normal | Open the commit staging panel (`:DiffBanditCommitPanel`) |

These live under the `<leader>gb` **DiffBandit** sub-group in which-key, alongside
diffview's `<leader>gd`/`gh`/`gH`/`gc`.

### Inside a diff session

diffbandit sets its own buffer-local keys once a diff is open:

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next / previous hunk |
| `]f` / `[f` | Next / previous changed file |
| `<Space>` | Toggle stage for the hunk |
| `>>` / `<<` | Apply the left / right side |
| `u` | Undo last action |
| `q` | Close the diff session |

## Commands

Beyond the mapped commands above, the plugin also provides:

- `:DiffBandit path/left path/right` — compare two files
- `:DiffBanditBuffers 3 7` — compare two buffers by number
- `:DiffBanditFolderDiff path/left path/right` — recursive folder comparison
- `:DiffBanditMerge path/file` — resolve merge conflicts

## Config Notes

- Loaded with `require("diffbandit").setup()` (defaults) from
  `lua/config/diffbandit.lua`, wired into `lua/init.lua`.
- Requires Neovim 0.10+; git is optional (needed for the git-oriented commands),
  and a Nerd Font is optional for icons.
- Not in nixpkgs — built from a flake source input (`diffbandit-nvim-src`) via
  `buildVimPlugin` in `modules/plugins.nix`, the same pattern as agentic-nvim and
  notion-nvim.
