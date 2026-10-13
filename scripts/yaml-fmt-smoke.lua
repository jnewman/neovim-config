-- Smoke test for the yq_yaml formatter in lua/config/format.lua.
--
-- Sources the REAL config module, formats YAML buffers through conform, and
-- asserts the exact output: one blank line between top-level keys, with
-- top-level comment blocks kept together above the key they describe.
--
-- rtp must include the repo root (for require("config.format")) and
-- conform.nvim; yq must be on PATH. See scripts/yaml-fmt-smoke.sh.

require("config.format")

local cases = {
  {
    name = "comment blocks stay contiguous",
    input = {
      "# header one",
      "# header two",
      "foo: 1",
      "# about bar",
      "# more about bar",
      "bar:",
      "  # nested one",
      "  # nested two",
      "  baz: 2",
      "qux: 3 # trailing",
    },
    expected = {
      "# header one",
      "# header two",
      "foo: 1",
      "",
      "# about bar",
      "# more about bar",
      "bar:",
      "  # nested one",
      "  # nested two",
      "  baz: 2",
      "",
      "qux: 3 # trailing",
    },
  },
  {
    name = "idempotent on already-formatted input",
    input = { "a: 1", "", "# about b", "# more", "b: 2" },
    expected = { "a: 1", "", "# about b", "# more", "b: 2" },
  },
  {
    name = "multi-document resets spacing",
    input = { "a: 1", "b: 2", "---", "# c doc", "c: 3", "d: 4" },
    expected = { "a: 1", "", "b: 2", "---", "# c doc", "c: 3", "", "d: 4" },
  },
}

local failures = {}

for _, c in ipairs(cases) do
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, vim.fn.tempname() .. ".yml")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, c.input)
  vim.bo[buf].filetype = "yaml"

  local ok, err =
    pcall(require("conform").format, { bufnr = buf, async = false, timeout_ms = 10000 })
  local got = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if not ok then
    table.insert(failures, ("%s: format error: %s"):format(c.name, err))
  elseif not vim.deep_equal(got, c.expected) then
    table.insert(
      failures,
      ("%s:\n  expected:\n    %s\n  got:\n    %s"):format(
        c.name,
        table.concat(c.expected, "\n    "),
        table.concat(got, "\n    ")
      )
    )
  end
end

if #failures > 0 then
  io.stderr:write("FAIL:\n" .. table.concat(failures, "\n") .. "\n")
  vim.cmd("cquit 1")
else
  print(("OK: %d yaml formatting cases passed"):format(#cases))
  vim.cmd("qall!")
end
