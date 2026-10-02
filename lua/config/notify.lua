-- Popup toast notifications. noice.nvim (config.noice) takes over vim.notify
-- and routes it through this plugin's "notify" view automatically — nothing
-- else to wire up here.
-- background_colour is what fades blend toward. Its default, NotifyBackground,
-- links to Normal, whose bg is cleared for terminal transparency -- so it would
-- warn and fade through black. A function is re-read on every render, so it
-- follows <leader>tt and OS light/dark switches.
require("notify").setup({
  background_colour = require("config.colorscheme").background,
})
