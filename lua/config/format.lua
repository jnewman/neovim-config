-- Every formatter runs natively off PATH — the flake wraps nvim with the
-- `lsp-tools` bundle (modules/lsp-tools.nix) on its PATH.

-- stdin formatter, e.g. `ruff format -`.
local function stdin_fmt(binary, ...)
  local extra = { ... }
  return {
    command = binary,
    args = function(_)
      return vim.list_extend({}, extra)
    end,
    stdin = true,
    timeout_ms = 10000,
  }
end

-- stdin formatter that also needs the buffer's filename appended.
local function stdin_fmt_filename(binary, ...)
  local extra = { ... }
  return {
    command = binary,
    args = function(_, ctx)
      local base = vim.list_extend({}, extra)
      table.insert(base, ctx.filename)
      return base
    end,
    stdin = true,
    timeout_ms = 10000,
  }
end

-- awk program for yq_yaml. `seen`: a top-level entry has been printed in this
-- document; `in_comment`: the previous line was a top-level comment.
local yq_yaml_spacing = [[
/^(---|\.\.\.)/ { seen = 0; in_comment = 0; print; next }
/^#/ { if (seen && !in_comment) print ""; in_comment = 1; print; next }
/^[^ \t]/ { if (seen && !in_comment) print ""; seen = 1; in_comment = 0; print; next }
{ in_comment = 0; print }
]]

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yq_yaml" },
    json = { "yq_json" },
    python = { "ruff" },
    rust = { "rustfmt" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    go = { "gofmt" },
    scala = { "scalafmt" },
    haskell = { "ormolu" },
    ruby = { "rubocop" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    html = { "prettier" },
    markdown = { "prettier" },
    xml = { "xmllint" },
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
  },
  formatters = {
    ruff = stdin_fmt("ruff", "format", "-"),
    rustfmt = stdin_fmt("rustfmt"),
    gofmt = stdin_fmt("gofmt"),
    shfmt = stdin_fmt("shfmt"),
    xmllint = stdin_fmt("xmllint", "--format", "-"),
    terraform_fmt = stdin_fmt("terraform", "fmt", "-"),
    prettier = stdin_fmt_filename("prettier", "--stdin-filepath"),
    scalafmt = stdin_fmt_filename("scalafmt", "--stdin", "--assume-filename"),
    ormolu = stdin_fmt_filename("ormolu", "--stdin-input-file"),
    rubocop = stdin_fmt_filename("rubocop", "--stdin", "--autocorrect", "--format", "quiet"),
    clang_format = {
      command = "clang-format",
      args = function(_, ctx)
        return { "--assume-filename=" .. ctx.filename }
      end,
      stdin = true,
      timeout_ms = 10000,
    },
    -- yq, then a blank line before each top-level key except the first in a
    -- document. A run of top-level comments sticks to the key below it, so the
    -- blank line goes above the whole comment block, not between its lines.
    yq_yaml = {
      command = "sh",
      args = { "-c", "yq '.' - | awk \"$0\"", yq_yaml_spacing },
      stdin = true,
    },
    yq_json = {
      command = "yq",
      args = { "-o=json", ".", "-" },
      stdin = true,
    },
  },
  format_on_save = {
    timeout_ms = 10000,
    lsp_fallback = true,
  },
})
