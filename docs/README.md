# Documentation

## Editor

- [Core keymaps](editor.md) — non-plugin keybindings (window navigation, editing, bottom terminal)
- [Theme pairs](themes.md) — day/night colorscheme pairs, `<leader>tt`, OS appearance detection

## Plugins

Each plugin has its own doc page covering purpose, keybindings, and config notes.

### Colorschemes

Grouped into three day/night [theme pairs](themes.md).

- [belafonte-day](plugins/belafonte-day.md) — `earthy` day: Ghostty's Belafonte Day
- [melange-nvim](plugins/melange.md) — `earthy` night: warm low-contrast
- [fairyfloss](plugins/fairyfloss.md) — `cyber` day: soft purple with pastel accents
- [tokyonight-nvim](plugins/tokyonight.md) — `cyber` night: deep blue/purple (Moon)
- [django](plugins/django.md) — `emerald` day: dark green with warm accents
- [django-reborn-again](plugins/django-reborn-again.md) — `emerald` night: darker green

### Editor

- [nvim-treesitter](plugins/treesitter.md) — syntax highlighting and indentation
- [blink.cmp](plugins/blink-cmp.md) — completion engine
- [conform-nvim](plugins/conform.md) — format on save
- [nvim-autopairs](plugins/autopairs.md) — auto-close brackets and quotes
- [Comment.nvim](plugins/comment.md) — comment toggling
- [flash.nvim](plugins/flash.md) — jump-to-anywhere navigation
- [precognition.nvim](plugins/precognition.md) — virtual-text hints for available motions
- [indent-blankline.nvim](plugins/ibl.md) — indent guides and scope highlighting
- [rainbow-delimiters.nvim](plugins/rainbow-delimiters.md) — rainbow nested-delimiter highlighting
- [visual-whitespace.nvim](plugins/visual-whitespace.md) — highlight whitespace in the visual selection
- [hardtime.nvim](plugins/hardtime.md) — nudges toward better Vim motions
- [neorepl.nvim](plugins/neorepl.md) — in-editor Lua/Vimscript REPL (`:Repl`)
- [resession.nvim](plugins/resession.md) — save/restore editor sessions

### Markdown & Data

- [markview.nvim](plugins/markview.md) — in-editor markdown rendering
- [csvview.nvim](plugins/csvview.md) — CSV/TSV table viewer
- [mermaid preview](plugins/mermaid.md) — inline mermaid diagrams (image.nvim + mermaid-cli)

### HTTP / API

- [kulala.nvim](plugins/kulala.md) — HTTP/GraphQL/gRPC/WebSocket client for `.http`/`.rest` files (`<leader>R`)

### UI

- [lualine.nvim](plugins/lualine.md) — statusline
- [bufferline.nvim](plugins/bufferline.md) — buffer tab bar
- [incline.nvim](plugins/incline.md) — floating per-window filename label
- [noice.nvim](plugins/noice.md) — cmdline/messages/popupmenu UI
- [nvim-notify](plugins/notify.md) — popup toast notifications (noice's notify view)
- [fidget.nvim](plugins/fidget.md) — LSP progress notifications
- [which-key.nvim](plugins/which-key.md) — keymap prefix legend
- [oil.nvim](plugins/oil.md) — file explorer as an editable buffer

### Git & GitHub

- [gitsigns-nvim](plugins/gitsigns.md) — git signs in the gutter, hunk actions
- [diffview-nvim](plugins/diffview.md) — diff viewer and git history browser
- [octo-nvim](plugins/octo.md) — GitHub PRs and issues in Neovim

### AI / Agent

- [agentic-nvim](plugins/agentic.md) — in-editor AI agent chat (ACP, defaults to Claude)

### Notes

- [notion.nvim](plugins/notion.md) — create, browse, and sync Notion pages from Neovim

### Dependencies

- [telescope-nvim](plugins/telescope.md) — fuzzy finder (used by octo and notion)
- [plenary-nvim](plugins/plenary.md) — Lua utility library (required by telescope, octo, and notion)
- [nui.nvim](plugins/nui.md) — UI component library (required by noice and hardtime)
