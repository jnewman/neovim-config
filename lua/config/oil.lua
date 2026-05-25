require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 2,
    max_width = 90,
    max_height = 0,
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
