-- In-editor markdown rendering ("WYSIWYG-style" editing).
--
-- markview renders markdown inline (headings, emphasis, lists, tables,
-- checkboxes, code blocks) and — via hybrid mode — reveals the raw markdown
-- only on the line under the cursor, so the document stays directly editable
-- while it looks rendered.
require("markview").setup({
  preview = {
    -- Render while reading/navigating and in command mode; raw text while
    -- inserting so typing is never obscured.
    modes = { "n", "no", "c" },
    -- Reveal raw markdown on the cursor line in normal mode (hybrid editing).
    hybrid_modes = { "n" },
    -- Reveal the entire cursor line as raw markdown (not just the node under
    -- the cursor), so the line you're editing is fully plain text.
    linewise_hybrid_mode = true,
  },
})

-- Commands are global toggles (capitalized variants take no buffer argument).
-- markview manages conceallevel for attached markdown buffers only, so it never
-- leaks into other filetypes.
local map = vim.keymap.set
map("n", "<leader>mt", "<cmd>Markview Toggle<cr>", { desc = "Toggle markview rendering" })
map("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", { desc = "Toggle split preview" })
map("n", "<leader>mh", "<cmd>Markview HybridToggle<cr>", { desc = "Toggle hybrid (raw on cursor line)" })
