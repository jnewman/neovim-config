local map = vim.keymap.set

require("diffbandit").setup()

map("n", "<leader>gbb", "<cmd>DiffBanditGit<cr>", { desc = "Changed files (DiffBandit)" })
map("n", "<leader>gbs", "<cmd>DiffBanditGit --staged<cr>", { desc = "Staged changes (DiffBandit)" })
map(
  "n",
  "<leader>gbf",
  "<cmd>DiffBanditGitCurrent<cr>",
  { desc = "Current file diff (DiffBandit)" }
)
map("n", "<leader>gbc", "<cmd>DiffBanditCommitPanel<cr>", { desc = "Commit panel (DiffBandit)" })
map("n", "<leader>gbl", "<cmd>DiffBanditGitLog<cr>", { desc = "Commit log (DiffBandit)" })
map("n", "<leader>gbm", "<cmd>DiffBanditGitMenu<cr>", { desc = "Git menu (DiffBandit)" })
map("n", "<leader>gbq", "<cmd>DiffBanditClose<cr>", { desc = "Close DiffBandit" })
