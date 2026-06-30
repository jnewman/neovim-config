-- Track the Oil toggle pane so we can tell it apart from the main editor windows.
local oil_state = { win = nil }

-- When using the left Oil pane, open files in the main window on the right
-- instead of replacing the pane. Directories still navigate within the pane.
local function open_in_main()
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  -- Directories: keep navigating inside the Oil pane as usual.
  if entry.type == "directory" then
    oil.select()
    return
  end

  local dir = oil.get_current_dir()
  if not dir then
    return
  end
  local path = dir .. entry.name
  local oil_win = vim.api.nvim_get_current_win()

  -- Find a real (non-floating, non-Oil) window to open the file in.
  local target
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= oil_win and vim.api.nvim_win_get_config(win).relative == "" then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype ~= "oil" then
        target = win
        break
      end
    end
  end

  if target then
    vim.api.nvim_set_current_win(target)
  else
    -- No other window yet: split one off to the right of the pane.
    vim.cmd("rightbelow vsplit")
  end
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 2,
    max_width = 90,
    max_height = 0,
  },
  keymaps = {
    ["<CR>"] = open_in_main,
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Toggle Oil in a small pane on the left
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
