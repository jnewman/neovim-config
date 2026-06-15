local function docker_fmt(binary, ...)
  local extra = { ... }
  return {
    command = "docker",
    args = function(_)
      local base = { "exec", "-i", "nvim-lsp", binary }
      for _, v in ipairs(extra) do
        table.insert(base, v)
      end
      return base
    end,
    stdin = true,
    timeout_ms = 10000,
  }
end

local function docker_fmt_filename(binary, ...)
  local extra = { ... }
  return {
    command = "docker",
    args = function(_, ctx)
      local base = { "exec", "-i", "nvim-lsp", binary }
      for _, v in ipairs(extra) do
        table.insert(base, v)
      end
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
    python = { "ruff_docker" },
    rust = { "rustfmt_docker" },
    typescript = { "prettier_docker" },
    typescriptreact = { "prettier_docker" },
    javascript = { "prettier_docker" },
    javascriptreact = { "prettier_docker" },
    go = { "gofmt_docker" },
    scala = { "scalafmt_docker" },
    haskell = { "ormolu_docker" },
    ruby = { "rubocop_docker" },
    c = { "clang_format_docker" },
    cpp = { "clang_format_docker" },
    sh = { "shfmt_docker" },
    bash = { "shfmt_docker" },
    html = { "prettier_docker" },
    markdown = { "prettier_docker" },
    xml = { "xmllint_docker" },
    terraform = { "terraform_fmt_docker" },
    ["terraform-vars"] = { "terraform_fmt_docker" },
  },
  formatters = {
    ruff_docker = docker_fmt("ruff", "format", "-"),
    rustfmt_docker = docker_fmt("rustfmt"),
    gofmt_docker = docker_fmt("gofmt"),
    shfmt_docker = docker_fmt("shfmt"),
    xmllint_docker = docker_fmt("xmllint", "--format", "-"),
    terraform_fmt_docker = docker_fmt("terraform", "fmt", "-"),
    prettier_docker = docker_fmt_filename("prettier", "--stdin-filepath"),
    scalafmt_docker = docker_fmt_filename("scalafmt", "--stdin", "--assume-filename"),
    ormolu_docker = docker_fmt_filename("ormolu", "--stdin-input-file"),
    rubocop_docker = docker_fmt_filename(
      "rubocop",
      "--stdin",
      "--autocorrect",
      "--format",
      "quiet"
    ),
    clang_format_docker = {
      command = "docker",
      args = function(_, ctx)
        return { "exec", "-i", "nvim-lsp", "clang-format", "--assume-filename=" .. ctx.filename }
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
