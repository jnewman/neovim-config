# Spec: Plugin Expansion — Completion, Navigation, and UI

## Overview

Add 8 new plugins to the Neovim config and document all plugins (new and
existing) with usage instructions in README.md. Each plugin gets a dedicated
`lua/config/<plugin>.lua` file matching the depth of existing configs
(lsp.lua, format.lua, etc.) — keymaps, settings, and integrations wired up.

## Plugins to Add

| Plugin | Role |
|--------|------|
| blink.cmp | Completion engine with LSP, buffer, and path sources |
| oil.nvim | File explorer as an editable buffer |
| which-key.nvim | Keymap prefix legend (floating popup) |
| nvim-autopairs | Auto-close brackets, quotes, and tags |
| Comment.nvim | Line and block comment toggle |
| lualine.nvim | Statusline with git, diagnostics, and mode sections |
| indent-blankline.nvim | Indent scope guides |
| flash.nvim | Jump-to-anywhere navigation |

## Functional Requirements

1. Each plugin declared in `modules/plugins.nix` and copyable via `task build`
2. Each plugin has its own `lua/config/<name>.lua` with full keymaps and settings
3. All config files required in `lua/init.lua`
4. blink.cmp wired to the existing lua_ls LSP and conform formatters
5. lualine.nvim uses the active colorscheme (catppuccin integration)
6. which-key.nvim registers prefix labels for all existing `<leader>` groups
7. nvim-autopairs integrates with blink.cmp to avoid double-inserting close chars
8. README.md updated with a "Usage" section covering all plugins (new + existing)

## Acceptance Criteria

- `task build` + `task install` produces a working nvim with all 8 plugins loading
- Completion popup appears on LSP-backed files with Tab/S-Tab navigation
- `-` opens oil.nvim in the current file's directory
- `<leader>?` shows which-key prefix legend
- `s` triggers flash jump; `S` triggers treesitter select
- `gcc` toggles line comment; `gc` in visual toggles block comment
- Statusline shows mode, filename, git branch, diagnostics, filetype, position
- Indent guides visible on indented code
- `luacheck lua/` passes (0 errors/warnings)
- README.md has usage instructions for all plugins

## Out of Scope

- Snippet engine (luasnip) — separate track if desired
- DAP (debugger) setup
- Additional LSP servers beyond lua_ls
