# Implementation Plan: Plugin Expansion

## Phase 1: Add Plugins and Wire Configs
<!-- execution: parallel -->

- [ ] Task 1: Add 8 plugins to modules/plugins.nix
  <!-- files: modules/plugins.nix -->
  - [ ] blink-cmp, oil-nvim, which-key-nvim, nvim-autopairs, comment-nvim, lualine-nvim, indent-blankline-nvim, flash-nvim

- [ ] Task 2: Create lua/config/completion.lua (blink.cmp)
  <!-- files: lua/config/completion.lua -->
  - [ ] Sources: lsp, buffer, path
  - [ ] Keymaps: Tab/S-Tab cycle, Enter confirm, C-e dismiss
  - [ ] nvim-autopairs integration (disable blink's auto-confirm on open pairs)

- [ ] Task 3: Create lua/config/oil.lua
  <!-- files: lua/config/oil.lua -->
  - [ ] Keymap: `-` opens oil in current file's directory (normal mode)
  - [ ] Show hidden files, float preview enabled

- [ ] Task 4: Create lua/config/which-key.lua
  <!-- files: lua/config/which-key.lua -->
  - [ ] Register prefix labels: `<leader>g` → Git, `<leader>f` → Find, etc.
  - [ ] Trigger on `<leader>` and `g` prefixes

- [ ] Task 5: Create lua/config/autopairs.lua
  <!-- files: lua/config/autopairs.lua -->
  - [ ] Enable treesitter-aware pairing
  - [ ] blink.cmp event integration

- [ ] Task 6: Create lua/config/comment.lua
  <!-- files: lua/config/comment.lua -->
  - [ ] gcc → toggle line comment
  - [ ] gc in visual → toggle block comment

- [ ] Task 7: Create lua/config/lualine.lua
  <!-- files: lua/config/lualine.lua -->
  - [ ] Sections: mode | filename+modified | git branch | diagnostics | filetype | position
  - [ ] catppuccin theme

- [ ] Task 8: Create lua/config/ibl.lua (indent-blankline)
  <!-- files: lua/config/ibl.lua -->
  - [ ] Scope highlighting enabled
  - [ ] Exclude filetypes: dashboard, help, terminal

- [ ] Task 9: Create lua/config/flash.lua
  <!-- files: lua/config/flash.lua -->
  - [ ] s → flash jump (normal + visual)
  - [ ] S → treesitter select
  - [ ] r → remote flash (operator-pending)

- [ ] Task 10: Wire all new configs in lua/init.lua
  <!-- files: lua/init.lua -->
  <!-- depends: task2, task3, task4, task5, task6, task7, task8, task9 -->
  - [ ] require each new config module in order

- [ ] Task: Conductor - User Manual Verification 'Phase 1: Add Plugins and Wire Configs' (Protocol in workflow.md)

## Phase 2: Build, Install, and Verify

- [ ] Task 1: Run task build + task install
- [ ] Task 2: Run luacheck — confirm 0 errors/warnings

- [ ] Task: Conductor - User Manual Verification 'Phase 2: Build, Install, and Verify' (Protocol in workflow.md)

## Phase 3: Documentation

- [ ] Task 1: Update README.md with usage section for all plugins (new + existing)

- [ ] Task: Conductor - User Manual Verification 'Phase 3: Documentation' (Protocol in workflow.md)
