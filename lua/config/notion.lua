-- Notion credentials come from secretspec (1Password provider) on demand, not at
-- startup: nvim launches without touching 1Password. Each Notion workspace is a
-- secretspec profile in ~/.config/secretspec/notion.toml (family, sedira). Picking
-- a project re-runs notion.setup() with that profile, and *that* is when secretspec
-- resolves NOTION_TOKEN / NOTION_DATABASE_ID from 1Password.
local secretspec_manifest = vim.fn.expand("~/.config/secretspec/notion.toml")
local projects = { "family", "sedira" }

-- Load the plugin once, token-less, so its commands exist. A Notion action before
-- selecting a project just warns (no token configured); pick one with <leader>nP.
require("notion").setup({
  page_size = 10,
  debug = false,
  sync_debounce_ms = 1000,
  use_telescope = nil, -- auto-detect (telescope-nvim is in the pack)
})

local function use_project(profile)
  local db = vim.fn.system({
    "secretspec", "get", "NOTION_DATABASE_ID", "-f", secretspec_manifest, "-P", profile,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("secretspec: could not read Notion DB id for '" .. profile .. "'", vim.log.levels.ERROR)
    return
  end
  require("notion").setup({
    notion_token_cmd = { "secretspec", "get", "NOTION_TOKEN", "-f", secretspec_manifest, "-P", profile },
    database_id = vim.trim(db),
    page_size = 10,
    debug = false,
    sync_debounce_ms = 1000,
    use_telescope = nil,
  })
  vim.notify("Notion project: " .. profile)
end

vim.api.nvim_create_user_command("NotionProject", function(opts)
  use_project(opts.args)
end, {
  nargs = 1,
  complete = function()
    return projects
  end,
  desc = "Switch active Notion project (secretspec profile)",
})

local map = vim.keymap.set

-- Notion actions under the <leader>n group
map("n", "<leader>nP", function()
  vim.ui.select(projects, { prompt = "Notion project" }, function(choice)
    if choice then
      use_project(choice)
    end
  end)
end, { desc = "Switch Notion project" })
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
