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
- `enable_builtin = false` — disables octo's built-in highlights in favour of the active colorscheme
- Requires `gh auth login` to be completed before first use
