local flash = require("flash")

flash.setup({
  modes = {
    search = { enabled = false },
  },
})

local map = vim.keymap.set

map({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash jump" })

map({ "n", "x", "o" }, "S", function()
  flash.treesitter()
end, { desc = "Flash treesitter select" })

map("o", "r", function()
  flash.remote()
end, { desc = "Flash remote" })

map({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, { desc = "Flash treesitter search" })
