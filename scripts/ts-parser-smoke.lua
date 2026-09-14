-- Headless smoke test for the prebuilt tree-sitter parser pack.
--
-- Asserts that, for a representative set of the config's `ensure_installed`
-- languages, the compiled parser loads and a highlighter attaches WITHOUT any
-- compiler / tree-sitter CLI on PATH. Run via:
--
--   nvim --headless -u NONE \
--     --cmd "set packpath^=<dir-with-pack/test/start>" \
--     -l scripts/ts-parser-smoke.lua
--
-- Exits 0 on success, 1 (with a report) on any failure.

local samples = {
  lua = "local x = 1\n",
  go = "package main\nfunc main() {}\n",
  python = "def f(x):\n    return x\n",
  rust = "fn main() {}\n",
  ruby = "def f; end\n",
  json = '{"a": 1}\n',
  yaml = "a: 1\n",
  bash = "echo hi\n",
  markdown = "# title\n",
}

local failures = {}

for ft, text in pairs(samples) do
  local lang = vim.treesitter.language.get_lang(ft) or ft
  -- 1. parser loads from a bundled .so (no compilation)
  local ok_add = pcall(vim.treesitter.language.add, lang)
  if not ok_add then
    table.insert(failures, ("%s: parser %q failed to load"):format(ft, lang))
  else
    -- 2. a highlighter query resolves (queries bundled alongside the parser)
    local ok_q, q = pcall(vim.treesitter.query.get, lang, "highlights")
    if not ok_q or not q then
      table.insert(failures, ("%s: no highlights query for %q"):format(ft, lang))
    else
      -- 3. parsing the sample actually produces a tree
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
      vim.bo[buf].filetype = ft
      local ok_start = pcall(vim.treesitter.start, buf, lang)
      if not ok_start then
        table.insert(failures, ("%s: vim.treesitter.start failed"):format(ft))
      end
    end
  end
end

if #failures > 0 then
  io.stderr:write("PARSER SMOKE FAILED:\n  " .. table.concat(failures, "\n  ") .. "\n")
  vim.cmd("cquit 1")
else
  io.stdout:write("PARSER SMOKE OK: all sampled parsers loaded + highlighted\n")
  vim.cmd("quit")
end
