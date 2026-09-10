# notion.nvim

## Purpose

Manage Notion pages from Neovim. [`ALT-F4-LLC/notion.nvim`](https://github.com/ALT-F4-LLC/notion.nvim)
talks to the Notion API to create, browse, edit, sync, and delete pages in a
configured database, editing page content as a normal buffer. Page browsing uses
telescope.nvim (already in this config) when available.

## Prerequisite

The plugin needs a Notion API token and a database ID per workspace. Both are
fetched from [secretspec](https://secretspec.dev) (1Password provider) **on
demand** — nothing is read at startup, so launching nvim never prompts 1Password.
Each Notion workspace is a secretspec **profile** in
`~/.config/secretspec/notion.toml`:

- `family` — personal workspace
- `sedira` — work workspace

The manifest holds declarations only (no secret values); the values live in
1Password. Populate them once per profile:

```bash
SS=~/.config/secretspec/notion.toml
secretspec check -f $SS -P family    # prompts for NOTION_TOKEN + NOTION_DATABASE_ID
secretspec check -f $SS -P sedira
```

Create an integration and grab the token at
<https://www.notion.so/my-integrations>, then share the target database with it;
the database ID is the 32-char hex in the database URL.

Select a workspace with `<leader>nP` (or `:NotionProject family|sedira`). That
re-runs `notion.setup()` with the chosen profile, resolving `NOTION_TOKEN` and
`NOTION_DATABASE_ID` from 1Password at that moment. Before a project is selected,
Notion actions just warn that no token is configured — the plugin loads
token-less at startup.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>nP` | Normal | Switch active Notion project (secretspec profile) |
| `<leader>nc` | Normal | Create a page (prompts for a title) |
| `<leader>ne` | Normal | Browse and edit pages |
| `<leader>nd` | Normal | Delete (archive) a page |
| `<leader>ns` | Normal | Sync the current buffer to Notion |
| `<leader>nb` | Normal | Open the current page in the browser |

The `<leader>n` prefix is registered as the **Notion** group in which-key.

`:NotionProject <family|sedira>` switches the active workspace (with tab
completion). The plugin also exposes commands directly: `:Notion create <title>`,
`:Notion edit [page_id]`, `:Notion delete`, plus `:NotionBrowser` and
`:NotionSync` (and the `:NotionCreate` / `:NotionEdit` / `:NotionDelete`
aliases).

## Config Notes

- Token/database resolve per-project from secretspec (1Password) via
  `notion_token_cmd` + a fetched `database_id`; `use_project()` in
  `lua/config/notion.lua` re-runs `setup()` with the selected profile. The plugin
  still honors `$NOTION_TOKEN` / `$NOTION_DATABASE_ID` as a fallback, but this
  config never sets them.
- `page_size = 10` — pages fetched per API request.
- `use_telescope = nil` — auto-detect; telescope-nvim is bundled so browsing uses
  it.
- Depends on plenary-nvim and telescope-nvim, both already in the pack.
- Packaged from a flake source input (`notion-nvim-src` in `flake.nix`), not from
  nixpkgs, and built with `buildVimPlugin` in `modules/plugins.nix` (the nvim
  require-check is disabled with `doCheck = false`, matching agentic-nvim).
- Config lives in `lua/config/notion.lua`, loaded from `lua/init.lua`.
