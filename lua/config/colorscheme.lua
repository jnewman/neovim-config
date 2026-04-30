require("catppuccin").setup({
  flavour = "auto", -- respects vim.o.background (dark → mocha, light → latte)
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
  dim_inactive = {
    enabled = false,
  },
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
    gitsigns = true,
    telescope = { enabled = true },
    which_key = false,
  },
})

vim.cmd.colorscheme("catppuccin")

-- Toggle between light and dark
vim.keymap.set("n", "<leader>tt", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end, { desc = "Toggle light/dark theme" })
