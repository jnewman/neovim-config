require("resession").setup()

local map = vim.keymap.set
map("n", "<leader>ss", function()
  require("resession").save()
end, { desc = "Save session" })
map("n", "<leader>sl", function()
  require("resession").load()
end, { desc = "Load session" })
map("n", "<leader>sd", function()
  require("resession").delete()
end, { desc = "Delete session" })
