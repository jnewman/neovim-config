require("notion").setup({
  -- Token and database are read from the environment so no secrets live in the
  -- repo: notion.nvim falls back to $NOTION_TOKEN and $NOTION_DATABASE_ID when
  -- these are unset. Export them (e.g. via a secrets manager) before use.
  -- notion_token_cmd = { "doppler", "secrets", "get", "--plain", "NOTION_TOKEN" },
  page_size = 10,
  debug = false,
  sync_debounce_ms = 1000,
  use_telescope = nil, -- auto-detect (telescope-nvim is in the pack)
})

local map = vim.keymap.set

-- Notion actions under the <leader>n group
map("n", "<leader>nc", function()
  vim.ui.input({ prompt = "Notion page title: " }, function(title)
    if title and title ~= "" then
      require("notion.api").create_page(title)
    end
  end)
end, { desc = "Create page" })
map("n", "<leader>ne", function()
  require("notion.api").list_and_edit_pages()
end, { desc = "Edit/browse pages" })
map("n", "<leader>nd", function()
  require("notion.api").delete_page()
end, { desc = "Delete (archive) page" })
map("n", "<leader>ns", function()
  require("notion.api").sync_page()
end, { desc = "Sync buffer to Notion" })
map("n", "<leader>nb", function()
  require("notion.api").open_current_page_in_browser()
end, { desc = "Open page in browser" })
