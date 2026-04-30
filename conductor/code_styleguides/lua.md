# Lua Style Guide (Neovim Config)

## Formatter

Use **stylua** for all formatting. Configuration in `stylua.toml`:
- `indent_type = "Spaces"`, `indent_width = 2`
- `column_width = 100`

## Module Structure

Each concern lives in its own file under a logical namespace:

```
lua/
  config/       -- options, keymaps, autocmds
  plugins/      -- one file per plugin or plugin group
```

Each file returns a table or calls setup directly — no side-effects at require time beyond what's necessary.

## Naming Conventions

- Variables and functions: `snake_case`
- Module-level constants: `UPPER_SNAKE_CASE`
- Private module locals: prefix with `_` is optional but consistent within a file

## Tables & Options

Use long-form table constructors for readability:

```lua
-- good
vim.opt.number = true
vim.opt.relativenumber = true

-- avoid
vim.cmd("set number relativenumber")
```

## Keymaps

Define all keymaps via `vim.keymap.set`. Always provide a `desc`:

```lua
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
```

## Plugin Setup

Call `require("plugin").setup({})` inside the plugin's lazy/nix load block. Do not call setup at module load time if the plugin may not be installed.

## Comments

Only comment non-obvious decisions. Do not narrate what the code does.
