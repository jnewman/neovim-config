require("agentic").setup({
  -- Talks to the `claude-agent-acp` CLI over the Agent Client Protocol.
  -- Install it on PATH first: npm i -g @agentclientprotocol/claude-agent-acp
  provider = "claude-agent-acp",

  acp_providers = {
    ["claude-agent-acp"] = {
      env = {
        -- claude-agent-acp's SDK bundles a prebuilt generic-linux `claude`
        -- binary that requests /lib64/ld-linux-x86-64.so.2. On NixOS that is
        -- the stub-ld, which refuses to run it, so the subprocess dies and the
        -- SDK crashes with an unhandled `write EPIPE`. Point the SDK at the
        -- nixpkgs `claude` (Claude Code) on PATH instead.
        CLAUDE_CODE_EXECUTABLE = "claude",
      },
    },
  },
})

local map = vim.keymap.set
local agentic = function(fn)
  return function()
    require("agentic")[fn]()
  end
end

-- Toggle the chat sidebar from anywhere
map({ "n", "v", "i" }, "<C-\\>", agentic("toggle"), { desc = "Toggle Agentic chat" })

-- Session + context actions under the <leader>a (AI/Agent) group
map("n", "<leader>aa", agentic("toggle"), { desc = "Toggle chat" })
map("n", "<leader>an", agentic("new_session"), { desc = "New session" })
map("n", "<leader>ar", agentic("restore_session"), { desc = "Restore session" })
map("n", "<leader>ap", agentic("switch_provider"), { desc = "Switch provider" })
map("n", "<leader>af", agentic("add_file"), { desc = "Add file to context" })
map(
  { "n", "v" },
  "<leader>ac",
  agentic("add_selection_or_file_to_context"),
  { desc = "Add selection/file to context" }
)
map("n", "<leader>ad", agentic("add_buffer_diagnostics"), { desc = "Add buffer diagnostics" })
