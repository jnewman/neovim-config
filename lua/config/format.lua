require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yq" },
    json = { "yq_json" },
  },
  formatters = {
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
