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
    -- blank line before each top-level key except the first
    yq_yaml = {
      command = "sh",
      args = {
        "-c",
        "yq '.' - | awk 'NR>1 && /^[^ \\t]/ && !/^---/ && !/^\\.\\.\\./ { print \"\" } { print }'",
      },
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
