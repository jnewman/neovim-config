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
  -- Palette overridden to match the Ghostty "Cyberpunk" theme: a purple base
  -- (#332a57) with mint-green / hot-pink / electric-cyan neon accents, rather
  -- than cyberdream's default near-black bg and lime-green accents.
  colors = {
    bg = "#332a57",
    bg_alt = "#3d3266",
    fg = "#e5e5e5",
    green = "#00fbac",
    cyan = "#1bccfd",
    blue = "#00bfff",
    red = "#ff7092",
    pink = "#ff7092",
    magenta = "#df95ff",
    purple = "#df95ff",
    yellow = "#fffa6a",
  },
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

vim.cmd.colorscheme("cyberdream")

local themes = {
  "tokyonight",
  "cyberdream",
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
