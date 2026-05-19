local map = vim.keymap.set

require("diffview").setup()

map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff working tree" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File git history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Branch git history" })
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" })
