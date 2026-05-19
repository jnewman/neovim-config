-- Neovim globals
globals = {
  "vim",
}

-- Allow accessing undefined fields on globals (vim.* is vast)
allow_defined_top = true

-- Ignore line length (stylua handles formatting)
max_line_length = false

-- Files to check
include_files = { "lua/**/*.lua" }
