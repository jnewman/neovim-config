# notion.nvim

## Purpose

Manage Notion pages from Neovim. [`ALT-F4-LLC/notion.nvim`](https://github.com/ALT-F4-LLC/notion.nvim)
talks to the Notion API to create, browse, edit, sync, and delete pages in a
configured database, editing page content as a normal buffer. Page browsing uses
telescope.nvim (already in this config) when available.

## Prerequisite

The plugin needs a Notion API token and a database ID. To keep secrets out of the
repo, `lua/config/notion.lua` leaves them unset so the plugin falls back to
environment variables:

```bash
export NOTION_TOKEN="secret_xxx"        # integration token
export NOTION_DATABASE_ID="xxxxxxxx"    # target database
```

Create an integration and grab the token at
<https://www.notion.so/my-integrations>, then share the target database with it.
A missing token does **not** abort `init.lua` — setup only emits a warning, and
the error surfaces when you run a command. To pull the token from a secrets
manager instead, uncomment `notion_token_cmd` in `lua/config/notion.lua`.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>nc` | Normal | Create a page (prompts for a title) |
| `<leader>ne` | Normal | Browse and edit pages |
| `<leader>nd` | Normal | Delete (archive) a page |
| `<leader>ns` | Normal | Sync the current buffer to Notion |
| `<leader>nb` | Normal | Open the current page in the browser |

The `<leader>n` prefix is registered as the **Notion** group in which-key.

The plugin also exposes commands directly: `:Notion create <title>`,
`:Notion edit [page_id]`, `:Notion delete`, plus `:NotionBrowser` and
`:NotionSync` (and the `:NotionCreate` / `:NotionEdit` / `:NotionDelete`
aliases).

## Config Notes

- Token/database resolve from `$NOTION_TOKEN` / `$NOTION_DATABASE_ID` — nothing is
  hardcoded. Set `notion_token_cmd` to source the token from a secrets manager.
- `page_size = 10` — pages fetched per API request.
- `use_telescope = nil` — auto-detect; telescope-nvim is bundled so browsing uses
  it.
- Depends on plenary-nvim and telescope-nvim, both already in the pack.
- Packaged from a flake source input (`notion-nvim-src` in `flake.nix`), not from
  nixpkgs, and built with `buildVimPlugin` in `modules/plugins.nix` (the nvim
  require-check is disabled with `doCheck = false`, matching agentic-nvim).
- Config lives in `lua/config/notion.lua`, loaded from `lua/init.lua`.
