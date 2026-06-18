-- A nix host (detected by the `nix` executable on PATH) runs formatters natively
-- from this repo's flake `lsp-tools` package. Every other host runs them inside the
-- nvim-lsp Docker container (docker exec -i nvim-lsp <binary>). The `_docker`-suffixed
-- formatter keys below cover both modes via these helpers.
local use_docker = vim.fn.executable("nix") == 0

-- Build the leading argv for a containerised binary, or an empty list when native.
local function prefix(binary)
  if use_docker then
    return { "exec", "-i", "nvim-lsp", binary }
  end
  return {}
end

-- stdin formatter, e.g. `ruff format -`.
local function docker_fmt(binary, ...)
  local extra = { ... }
  return {
    command = use_docker and "docker" or binary,
    args = function(_)
      return vim.list_extend(prefix(binary), extra)
    end,
    stdin = true,
    timeout_ms = 10000,
  }
end

-- stdin formatter that also needs the buffer's filename appended.
local function docker_fmt_filename(binary, ...)
  local extra = { ... }
  return {
    command = use_docker and "docker" or binary,
    args = function(_, ctx)
      local base = vim.list_extend(prefix(binary), extra)
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
      command = use_docker and "docker" or "clang-format",
      args = function(_, ctx)
        local base = prefix("clang-format")
        table.insert(base, "--assume-filename=" .. ctx.filename)
        return base
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
