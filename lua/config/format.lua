require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yq_yaml" },
    json = { "yq_json" },
  },
  formatters = {
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
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
