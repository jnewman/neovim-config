local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better window navigation (keep Vim defaults, add <C-hjkl> convenience)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep cursor centred on search jumps
map("n", "n", "nzzzv", { desc = "Next search result (centred)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centred)" })

-- Format current buffer
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- Telescope fuzzy finding (<leader>f "Find" group)
-- Require lazily so keymap setup doesn't depend on telescope being loaded yet.
map("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Grep files" })
map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Find buffers" })
map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, { desc = "Find help" })

-- Toggle a terminal in a horizontal split at the bottom
local terminal_state = { buf = nil, win = nil }
local function toggle_terminal()
  -- If the terminal window is open, close it (keeps the buffer/session alive).
  if terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_hide(terminal_state.win)
    terminal_state.win = nil
    return
  end

  -- Open a bottom split sized to ~30% of the editor height.
  vim.cmd("botright split")
  terminal_state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(terminal_state.win, math.floor(vim.o.lines * 0.3))

  -- Reuse the existing terminal buffer if we have one, else start a new shell.
  if terminal_state.buf and vim.api.nvim_buf_is_valid(terminal_state.buf) then
    vim.api.nvim_win_set_buf(terminal_state.win, terminal_state.buf)
  else
    vim.cmd("terminal")
    terminal_state.buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd("startinsert")
end

map({ "n", "t" }, "<C-/>", toggle_terminal, { desc = "Toggle bottom terminal" })

-- Leave terminal-insert mode with <Esc><Esc>
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
