require("octo").setup({
  use_local_fs = false,
  enable_builtin = true,
  default_remote = { "upstream", "origin" },
  picker = "telescope",
})

local map = vim.keymap.set

-- PR workflow
map("n", "<leader>gpl", "<cmd>Octo pr list<cr>", { desc = "List PRs" })
map("n", "<leader>gpo", "<cmd>Octo pr<cr>", { desc = "Open current branch PR" })
map("n", "<leader>gpc", "<cmd>Octo pr create<cr>", { desc = "Create PR" })
map("n", "<leader>grs", "<cmd>Octo review start<cr>", { desc = "Start PR review" })
map("n", "<leader>grS", "<cmd>Octo review submit<cr>", { desc = "Submit PR review" })

-- Issues
map("n", "<leader>gil", "<cmd>Octo issue list<cr>", { desc = "List issues" })
