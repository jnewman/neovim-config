# octo-nvim

## Purpose

GitHub integration inside Neovim. Browse, create, and review pull requests and issues without leaving the editor. Uses telescope.nvim as the picker UI and the `gh` CLI for GitHub API access.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gpl` | Normal | List open PRs (telescope picker) |
| `<leader>gpo` | Normal | Open / edit a PR |
| `<leader>gpc` | Normal | Create a new PR |
| `<leader>grs` | Normal | Start a PR review |
| `<leader>grS` | Normal | Submit the current PR review |
| `<leader>gil` | Normal | List issues (telescope picker) |

## Config Notes

- `picker = "telescope"` — uses telescope for all list/search UIs
- `default_remote = { "upstream", "origin" }` — tries `upstream` first (useful in forks), then `origin`
- `use_local_fs = false` — PR files are fetched from GitHub, not read from the local checkout
- `enable_builtin = false` — no list of built-in actions when a command is run without one
- A `ColorScheme` autocmd repaints octo's highlight groups after every theme switch. Octo
  defines them once at setup from its own fixed GitHub palette, so without this the status
  marks (green checkmark, red X, purple merged) lose their colors when the theme changes.
  Groups that blend the palette with the theme (float backgrounds, file-panel titles) are
  re-derived from the new colorscheme rather than restored.
- Requires `gh auth login` to be completed before first use
