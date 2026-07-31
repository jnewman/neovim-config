local precognition = require("precognition")

precognition.setup({
  -- Start hidden so the hints appear only when you ask for them (toggle/peek),
  -- keeping the buffer uncluttered during normal editing.
  startVisible = false,
})

local map = vim.keymap.set

-- Motion hints live under the <leader>v "View" group.
map("n", "<leader>vp", function()
  precognition.toggle()
end, { desc = "Precognition toggle" })

map("n", "<leader>vP", function()
  precognition.peek()
end, { desc = "Precognition peek (until cursor moves)" })
