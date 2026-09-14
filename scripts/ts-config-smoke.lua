-- Integration smoke test for lua/config/treesitter.lua against the prebuilt pack.
--
-- Sources the REAL config module, opens sample files, and asserts an actual
-- treesitter highlighter attached and indentexpr is wired — proving the
-- main-branch port activates highlighting with only bundled parsers/queries.
--
-- rtp must include: the repo root (for require("config.treesitter")), the
-- nvim-treesitter plugin (indentexpr + queries source is the pack), and the
-- parser pack. See scripts/ts-smoke.sh.

require("config.treesitter")

local cases = {
  { ft = "go", text = { "package main", "func main() {}" } },
  { ft = "python", text = { "def f(x):", "    return x" } },
  { ft = "lua", text = { "local x = 1" } },
  { ft = "ruby", text = { "def f; end" } },
}

local failures = {}

for _, c in ipairs(cases) do
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, c.text)
  -- Setting filetype fires the FileType autocmd our config registered.
  vim.api.nvim_set_option_value("filetype", c.ft, { buf = buf })

  local hl = vim.treesitter.highlighter.active[buf]
  if not hl then
    table.insert(failures, ("%s: no active treesitter highlighter"):format(c.ft))
  end
  local ie = vim.api.nvim_get_option_value("indentexpr", { buf = buf })
  if not ie:find("nvim%-treesitter") then
    table.insert(failures, ("%s: indentexpr not wired (got %q)"):format(c.ft, ie))
  end
end

if #failures > 0 then
  io.stderr:write("CONFIG SMOKE FAILED:\n  " .. table.concat(failures, "\n  ") .. "\n")
  vim.cmd("cquit 1")
else
  io.stdout:write("CONFIG SMOKE OK: highlighter + indentexpr active from bundled parsers\n")
  vim.cmd("qall!")
end
