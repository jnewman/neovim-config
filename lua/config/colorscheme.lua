require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
  dim_inactive = { enabled = false },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
    blink_cmp = true,
    gitsigns = true,
    indent_blankline = { enabled = true },
    lualine = true,
    which_key = true,
  },
})

require("cyberdream").setup({
  transparent = false,
  italic_comments = true,
  hide_fillchars = false,
  borderless_telescope = false,
})

require("tokyonight").setup({
  style = "night",
  transparent = false,
  terminal_colors = true,
})

vim.cmd.colorscheme("cyberdream")

local themes = { "tokyonight", "catppuccin", "cyberdream" }
local current = 1

vim.keymap.set("n", "<leader>tt", function()
  current = (current % #themes) + 1
  vim.cmd.colorscheme(themes[current])
  vim.notify("Theme: " .. themes[current], vim.log.levels.INFO)
end, { desc = "Cycle colorscheme" })
