-- kulala.nvim — HTTP/GraphQL/gRPC/WebSocket client for .http / .rest files.
-- Requests are executed by the bundled `kulala-core` binary (provided by nix);
-- `curl` and the `tree-sitter` CLI must be on PATH (both are, on this host).
require("kulala").setup({
  -- Install kulala's own keymaps buffer-locally on http/rest files, under the
  -- <leader>R (REST) prefix. See docs/plugins/kulala.md for the full table.
  global_keymaps = true,
  global_keymaps_prefix = "<leader>R",

  ui = {
    -- Open the response in a split to the right of the request buffer.
    display_mode = "split",
    split_direction = "right",
    default_view = "body",
  },
})
