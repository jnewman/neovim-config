-- kulala.nvim — HTTP/GraphQL/gRPC/WebSocket client for .http / .rest files.
-- Requests are executed by the bundled `kulala-core` binary (provided by nix);
-- `curl` and the `tree-sitter` CLI must be on PATH (both are, on this host).

-- Show the last response body as YAML in a scratch split.
--
-- kulala 6.29.0 formats response bodies in `kulala-core` (`response_format`) and
-- no longer applies `contenttypes.formatter` when rendering, so there is no
-- config option for this — we convert the body file ourselves with `yq`.
local function show_body_as_yaml()
  local body_file = require("kulala.globals").BODY_FILE

  if vim.fn.filereadable(body_file) == 0 then
    return vim.notify("kulala: no response body yet", vim.log.levels.WARN)
  end

  local result = vim.system({ "yq", "-p", "json", "-o", "yaml", body_file }, { text = true }):wait()
  if result.code ~= 0 then
    return vim.notify("kulala: yq failed — " .. vim.trim(result.stderr or ""), vim.log.levels.ERROR)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(vim.trim(result.stdout), "\n"))
  vim.bo[buf].filetype = "yaml"
  vim.bo[buf].modifiable = false

  vim.api.nvim_open_win(buf, true, { split = "below", win = 0 })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, desc = "Close YAML view" })
end

-- Persistent scratchpad. kulala's own `kulala://scratchpad` buffer is overwritten
-- with `scratchpad_default_contents` on every open, cannot be `:w`ritten, and is
-- deleted on session load — so point <leader>Rb at a real file instead. The `.http`
-- extension keeps kulala's filetype keymaps attached; save it yourself with `:w`.
local scratchpad_file = vim.fs.joinpath(vim.fn.stdpath("data"), "kulala-scratchpad.http")

local function open_scratchpad()
  local is_new = vim.fn.filereadable(scratchpad_file) == 0
  vim.cmd("edit " .. vim.fn.fnameescape(scratchpad_file))

  if is_new then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, require("kulala.config").get().scratchpad_default_contents)
  end
end

require("kulala").setup({
  -- Install kulala's own keymaps buffer-locally on http/rest files, under the
  -- <leader>R (REST) prefix. See docs/plugins/kulala.md for the full table.
  -- A table is merged over kulala's defaults: entries below override the matching
  -- default (by name) and every other default keymap still applies.
  global_keymaps = {
    -- No `ft`, so this also works from inside the response window.
    ["Show body as YAML"] = { "<leader>Ry", show_body_as_yaml },
    -- Replaces kulala's throwaway scratchpad; drop this entry to get it back.
    ["Open scratchpad"] = { "<leader>Rb", open_scratchpad },
  },
  global_keymaps_prefix = "<leader>R",

  ui = {
    -- Open the response in a split to the right of the request buffer.
    display_mode = "split",
    split_direction = "right",
    default_view = "body",
    -- kulala sets foldmethod=indent on this window; without a foldlevel the
    -- Neovim default (0) shows every response body fully collapsed.
    win_opts = { wo = { foldlevel = 99 } },
  },
})
