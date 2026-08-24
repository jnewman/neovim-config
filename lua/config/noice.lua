-- Replaces the cmdline, messages, and popupmenu with a nicer floating UI.
-- Depends on nui.nvim; routes vim.notify() through nvim-notify (config.notify).
require("noice").setup({
  lsp = {
    progress = {
      -- fidget.nvim (config.fidget) owns LSP progress display instead.
      enabled = false,
    },
  },
})
