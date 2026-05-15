local map = vim.keymap.set

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local opts = { buffer = bufnr }

    -- Hunk navigation
    map("n", "]h", gs.next_hunk, vim.tbl_extend("force", opts, { desc = "Next hunk" }))
    map("n", "[h", gs.prev_hunk, vim.tbl_extend("force", opts, { desc = "Prev hunk" }))

    -- Hunk actions
    map({ "n", "v" }, "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
    map({ "n", "v" }, "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
    map("n", "<leader>hS", gs.stage_buffer, vim.tbl_extend("force", opts, { desc = "Stage buffer" }))
    map("n", "<leader>hu", gs.undo_stage_hunk, vim.tbl_extend("force", opts, { desc = "Undo stage hunk" }))
    map("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, vim.tbl_extend("force", opts, { desc = "Blame line" }))
    map("n", "<leader>hd", gs.diffthis, vim.tbl_extend("force", opts, { desc = "Diff this file" }))

    -- Text object
    map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<cr>", vim.tbl_extend("force", opts, { desc = "Select hunk" }))
  end,
})
