require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 2,
    max_width = 90,
    max_height = 0,
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Toggle Oil in a small pane on the left
local oil_state = { win = nil }
local function toggle_oil()
  -- If our Oil pane is open, close it (leaves the buffer alive).
  if oil_state.win and vim.api.nvim_win_is_valid(oil_state.win) then
    vim.api.nvim_win_hide(oil_state.win)
    oil_state.win = nil
    return
  end

  -- Open a left vertical split sized to ~25% of the editor width.
  vim.cmd("topleft vsplit")
  oil_state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(oil_state.win, math.floor(vim.o.columns * 0.25))

  -- Open Oil in this window (defaults to the current file's directory).
  require("oil").open()
end

vim.keymap.set("n", "<leader>e", toggle_oil, { desc = "Toggle Oil pane" })
