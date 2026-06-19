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

require("kanagawa").setup({
  theme = "wave",
  transparent = false,
  terminalColors = true,
})

require("onenord").setup({
  theme = "dark",
})

-- moonfly, melange, miasma, and aurora are configured via vim globals/options
-- rather than a setup() function.
vim.g.moonflyTransparent = false
vim.opt.background = "dark"
vim.g.aurora_italic = 1

vim.cmd.colorscheme("miasma")

local themes = {
  "tokyonight",
  "catppuccin",
  "cyberdream",
  "kanagawa",
  "moonfly",
  "melange",
  "onenord",
  "miasma",
  "aurora",
}
local current = 1

vim.keymap.set("n", "<leader>tt", function()
  current = (current % #themes) + 1
  vim.cmd.colorscheme(themes[current])
  vim.notify("Theme: " .. themes[current], vim.log.levels.INFO)
end, { desc = "Cycle colorscheme" })
