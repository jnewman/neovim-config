require("bufferline").setup({
  options = {
    -- nvim-web-devicons is installed for these; close icons stay off to match
    -- the icon-free look used elsewhere (lualine, incline).
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    diagnostics = "nvim_lsp",
  },
})

local map = vim.keymap.set
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
