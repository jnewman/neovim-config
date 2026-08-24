local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 300,
  icons = {
    mappings = true,
  },
})

wk.add({
  -- Top-level leader groups
  { "<leader>a", group = "AI/Agent" },
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Code" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>h", group = "Hunk" },
  { "<leader>m", group = "Markdown/Mermaid" },
  { "<leader>n", group = "Notion" },
  { "<leader>R", group = "REST/Kulala" },
  { "<leader>r", group = "Rename/Refactor" },
  { "<leader>s", group = "Session" },
  { "<leader>t", group = "Theme" },
  { "<leader>v", group = "View" },

  -- Git sub-groups
  { "<leader>gp", group = "Pull Request" },
  { "<leader>gr", group = "Review" },

  -- Show help popup for <leader>
  {
    "<leader>?",
    function()
      wk.show({ global = false })
    end,
    desc = "Buffer keymaps",
  },
})
