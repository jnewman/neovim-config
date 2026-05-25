require("ibl").setup({
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
  },
  exclude = {
    filetypes = {
      "help",
      "terminal",
      "lazy",
      "mason",
      "NvimTree",
      "Trouble",
      "TelescopePrompt",
    },
  },
})
