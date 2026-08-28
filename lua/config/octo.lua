require("octo").setup({
  use_local_fs = false,
  enable_builtin = false,
  default_remote = { "upstream", "origin" },
  picker = "telescope",
})

local map = vim.keymap.set

-- PR workflow
map("n", "<leader>gpl", "<cmd>Octo pr list<cr>", { desc = "List PRs" })
map("n", "<leader>gpo", "<cmd>Octo pr edit<cr>", { desc = "Open PR (picker)" })
map("n", "<leader>gpc", "<cmd>Octo pr create<cr>", { desc = "Create PR" })
map("n", "<leader>grs", "<cmd>Octo review start<cr>", { desc = "Start PR review" })
map("n", "<leader>grS", "<cmd>Octo review submit<cr>", { desc = "Submit PR review" })

-- Issues
map("n", "<leader>gil", "<cmd>Octo issue list<cr>", { desc = "List issues" })

-- Octo paints its status colors (green checkmarks, red Xs, purple merges) once at
-- setup() from its own fixed GitHub palette, but `:colorscheme` clears every
-- highlight group — and octo's setup skips any group name that already exists,
-- which a cleared group still does. So snapshot the groups it just defined and
-- repaint them on every theme switch.
local octo_hl = {}
for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
  if name:find("^Octo") then
    octo_hl[name] = def
  end
end

-- The handful of groups that mix the palette with the *theme's* float colors have
-- to be re-derived instead of restored verbatim, or floats keep the old theme's
-- background behind the new one's text.
local float_bg_groups = {
  "OctoGreenFloat",
  "OctoRedFloat",
  "OctoPurpleFloat",
  "OctoYellowFloat",
  "OctoBlueFloat",
  "OctoGreyFloat",
  "OctoEditable",
}

local derived_fg_groups = {
  OctoNormalFloat = "Normal",
  OctoFilePanelTitle = "Directory",
  OctoFilePanelCounter = "Identifier",
}

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for name, def in pairs(octo_hl) do
      vim.api.nvim_set_hl(0, name, def)
    end

    local float_bg =
      require("octo.ui.colors").get_background_color_of_highlight_group("NormalFloat")
    for _, name in ipairs(float_bg_groups) do
      vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", octo_hl[name] or {}, { bg = float_bg }))
    end

    for name, source in pairs(derived_fg_groups) do
      local fg = vim.api.nvim_get_hl(0, { name = source, link = false }).fg
      vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", octo_hl[name] or {}, { fg = fg }))
    end
  end,
})
