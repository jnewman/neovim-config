local map = vim.keymap.set

require("diffbandit").setup()

-- DiffBandit lives under a <leader>gb "DiffBandit" sub-group so its side-by-side
-- git views sit next to (but don't clash with) diffview's <leader>gd/gh/gH/gc.
map("n", "<leader>gbg", "<cmd>DiffBanditGit<cr>", { desc = "DiffBandit repo changes" })
map(
  "n",
  "<leader>gbf",
  "<cmd>DiffBanditGitCurrent<cr>",
  { desc = "DiffBandit current file vs git" }
)
map("n", "<leader>gbc", "<cmd>DiffBanditCommitPanel<cr>", { desc = "DiffBandit commit panel" })
