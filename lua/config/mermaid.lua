-- Inline mermaid diagram preview.
--
-- Renders mermaid to a PNG with the mermaid CLI (`mmdc`) and draws it inside
-- Neovim with image.nvim (kitty graphics protocol). It renders the whole buffer
-- for `.mermaid`/`.mmd` files, or the ```mermaid fenced block under the cursor
-- in markdown. Rendering is on demand (`<leader>mp`), not live.
--
-- Requirements (provided by lsp-tools.nix / the Brewfile):
--   * a graphics-capable terminal — kitty, ghostty, or wezterm
--   * `mmdc` (mermaid-cli) and ImageMagick on PATH

-- Treat standalone mermaid files as their own filetype so whole-buffer rendering
-- can key off it.
vim.filetype.add({
  extension = {
    mermaid = "mermaid",
    mmd = "mermaid",
  },
})

local image = require("image")

image.setup({
  backend = "kitty",
  -- Use the ImageMagick CLI rather than the magick luarock, so no luarocks
  -- install is needed; imagemagick already ships alongside mmdc.
  processor = "magick_cli",
  -- We render on demand, so disable the automatic markdown/neorg image passes.
  integrations = {},
})

local M = {}

-- The single live preview: a vertical split reused across renders.
local preview = { win = nil, buf = nil, image = nil }

local function notify(msg, level)
  vim.notify("[mermaid] " .. msg, level or vim.log.levels.INFO)
end

-- Return the mermaid source lines under the cursor, or (nil, reason).
local function get_source()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  if vim.bo.filetype == "mermaid" then
    return lines
  end

  -- Markdown: locate the enclosing ```mermaid fenced block.
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local fence_start, fence_lang
  for i = cursor, 1, -1 do
    local lang = lines[i]:match("^%s*```%s*([%w_-]*)")
    if lang ~= nil then
      fence_start, fence_lang = i, lang
      break
    end
  end
  -- A bare ``` (empty lang) above the cursor is a closing fence: not inside one.
  if not fence_start or fence_lang == "" then
    return nil, "cursor is not inside a ```mermaid block"
  end
  if fence_lang ~= "mermaid" then
    return nil, "fenced block under the cursor is `" .. fence_lang .. "`, not mermaid"
  end

  local fence_end
  for i = fence_start + 1, #lines do
    if lines[i]:match("^%s*```%s*$") then
      fence_end = i
      break
    end
  end
  if not fence_end or cursor > fence_end then
    return nil, "cursor is not inside a ```mermaid block"
  end

  return vim.list_slice(lines, fence_start + 1, fence_end - 1)
end

-- Open (or reuse) a scratch vertical split for the rendered image, keeping focus
-- on the source window.
local function open_preview_window()
  if preview.win and vim.api.nvim_win_is_valid(preview.win) then
    return
  end
  local src_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit")
  preview.win = vim.api.nvim_get_current_win()
  preview.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(preview.win, preview.buf)
  vim.bo[preview.buf].filetype = "mermaid_preview"
  vim.wo[preview.win].number = false
  vim.wo[preview.win].relativenumber = false
  vim.wo[preview.win].list = false
  vim.api.nvim_set_current_win(src_win)
end

function M.clear()
  if preview.image then
    preview.image:clear()
    preview.image = nil
  end
  if preview.win and vim.api.nvim_win_is_valid(preview.win) then
    vim.api.nvim_win_close(preview.win, true)
  end
  preview.win, preview.buf = nil, nil
end

local function render_png(png)
  open_preview_window()
  if preview.image then
    preview.image:clear()
  end
  preview.image = image.from_file(png, {
    window = preview.win,
    buffer = preview.buf,
    x = 0,
    y = 0,
    -- Fit to the split's width; aspect ratio is preserved.
    width = vim.api.nvim_win_get_width(preview.win),
  })
  preview.image:render()
end

function M.preview()
  local src, err = get_source()
  if not src then
    notify(err or "no mermaid source found", vim.log.levels.WARN)
    return
  end
  if vim.fn.executable("mmdc") == 0 then
    notify("`mmdc` (mermaid-cli) not found on PATH", vim.log.levels.ERROR)
    return
  end

  local input = vim.fn.tempname() .. ".mmd"
  local output = vim.fn.tempname() .. ".png"
  vim.fn.writefile(src, input)

  notify("rendering…")
  vim.system(
    -- `-s 3` super-samples for a sharp image; dark theme + transparent bg suits
    -- a dark terminal.
    { "mmdc", "-i", input, "-o", output, "-t", "dark", "-b", "transparent", "-s", "3" },
    { text = true },
    vim.schedule_wrap(function(res)
      if res.code ~= 0 then
        local detail = res.stderr ~= "" and res.stderr or res.stdout
        notify("mmdc failed: " .. (detail or "unknown error"), vim.log.levels.ERROR)
        return
      end
      render_png(output)
    end)
  )
end

vim.api.nvim_create_user_command(
  "MermaidPreview",
  M.preview,
  { desc = "Render mermaid diagram inline" }
)
vim.api.nvim_create_user_command("MermaidClear", M.clear, { desc = "Close the mermaid preview" })

local map = vim.keymap.set
map("n", "<leader>mp", M.preview, { desc = "Preview mermaid (render diagram)" })
map("n", "<leader>mx", M.clear, { desc = "Close mermaid preview" })

return M
