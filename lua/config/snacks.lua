-- snacks.nvim is a suite of independent modules; only the ones passed to
-- setup() are turned on. Just `scratch` here — noice/nvim-notify, telescope,
-- indent-blankline, and image.nvim already cover the jobs snacks' other
-- modules would do, so enabling them would mean two plugins fighting.
require("snacks").setup({
  scratch = {
    -- Scratch files live under stdpath("data")/scratch, keyed by cwd + git
    -- branch + count, so each project/branch gets its own buffer and
    -- `3<leader>.` opens a third one.
    enabled = true,
  },
})

local map = vim.keymap.set

map("n", "<leader>.", function()
  require("snacks").scratch()
end, { desc = "Toggle scratch buffer" })

map("n", "<leader>S", function()
  require("snacks").scratch.select()
end, { desc = "Select scratch buffer" })
