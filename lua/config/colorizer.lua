-- Inline color previews.
--
-- colorizer scans the buffer for color literals (`#rrggbb`, `rgb()`, `hsl()`)
-- and paints each one with its own color, so a palette in CSS/Lua/theme files
-- is readable without a separate picker.
require("colorizer").setup({
  user_default_options = {
    -- CSS color names ("red", "tan", "gold") match ordinary English words, so
    -- they light up prose and identifiers far more often than actual colors.
    names = false,
    RRGGBBAA = true,
    rgb_fn = true,
    hsl_fn = true,
    -- Paint the literal's own background rather than its text or a virtual dot.
    mode = "background",
  },
})

-- Color previews live under the <leader>v "View" group.
vim.keymap.set("n", "<leader>vC", "<cmd>ColorizerToggle<cr>", { desc = "Toggle color previews" })
