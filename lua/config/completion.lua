require("blink.cmp").setup({
  keymap = {
    ["<C-Space>"] = { "show", "fallback" },
    ["<C-e>"] = { "cancel", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
  },
  sources = {
    default = { "lsp", "buffer", "path" },
  },
  completion = {
    accept = {
      -- Let nvim-autopairs handle bracket insertion
      auto_brackets = { enabled = false },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    menu = {
      draw = {
        treesitter = { "lsp" },
      },
    },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
})
