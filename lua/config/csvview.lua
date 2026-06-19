-- CSV/TSV table viewer.
--
-- csvview parses delimited files and overlays aligned, bordered columns on top
-- of the raw buffer, so a comma-soup file reads like a table while staying
-- fully editable. It adds field text objects and Tab/Enter cell navigation
-- while a view is active.
require("csvview").setup({
  parser = {
    -- Lines starting with these are treated as comments, not table rows.
    comments = { "#", "//" },
  },
  view = {
    -- Draw real column borders (vs. "highlight", which only tints columns).
    display_mode = "border",
    spacing = 2,
  },
  keymaps = {
    -- Field text objects: `if`/`af` select the cell under the cursor.
    textobject_field_inner = { "if", mode = { "o", "x" } },
    textobject_field_outer = { "af", mode = { "o", "x" } },
    -- Move between cells/rows while a view is active.
    jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
    jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
    jump_next_row = { "<Enter>", mode = { "n", "v" } },
    jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
  },
})

-- Show the table view automatically when a CSV/TSV file is opened.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv" },
  group = vim.api.nvim_create_augroup("csvview_auto", { clear = true }),
  callback = function()
    require("csvview").enable()
  end,
})

vim.keymap.set("n", "<leader>vc", "<cmd>CsvViewToggle<cr>", { desc = "Toggle CSV table view" })
