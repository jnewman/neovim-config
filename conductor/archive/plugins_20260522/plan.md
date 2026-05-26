# Implementation Plan: Plugin Expansion

## Phase 1: Add Plugins and Wire Configs
<!-- execution: parallel -->

- [x] Task 1: Add 8 plugins to modules/plugins.nix
  <!-- files: modules/plugins.nix -->
  - [x] blink-cmp, oil-nvim, which-key-nvim, nvim-autopairs, comment-nvim, lualine-nvim, indent-blankline-nvim, flash-nvim

- [x] Task 2: Create lua/config/completion.lua (blink.cmp)
  <!-- files: lua/config/completion.lua -->
  - [x] Sources: lsp, buffer, path
  - [x] Keymaps: Tab/S-Tab cycle, Enter confirm, C-e dismiss
  - [x] nvim-autopairs integration (disable blink's auto-confirm on open pairs)

- [x] Task 3: Create lua/config/oil.lua
  <!-- files: lua/config/oil.lua -->
  - [x] Keymap: `-` opens oil in current file's directory (normal mode)
  - [x] Show hidden files, float preview enabled

- [x] Task 4: Create lua/config/which-key.lua
  <!-- files: lua/config/which-key.lua -->
  - [x] Register prefix labels: `<leader>g` → Git, `<leader>f` → Find, etc.
  - [x] Trigger on `<leader>` and `g` prefixes

- [x] Task 5: Create lua/config/autopairs.lua
  <!-- files: lua/config/autopairs.lua -->
  - [x] Enable treesitter-aware pairing
  - [x] blink.cmp event integration

- [x] Task 6: Create lua/config/comment.lua
  <!-- files: lua/config/comment.lua -->
  - [x] gcc → toggle line comment
  - [x] gc in visual → toggle block comment

- [x] Task 7: Create lua/config/lualine.lua
  <!-- files: lua/config/lualine.lua -->
  - [x] Sections: mode | filename+modified | git branch | diagnostics | filetype | position
  - [x] catppuccin theme

- [x] Task 8: Create lua/config/ibl.lua (indent-blankline)
  <!-- files: lua/config/ibl.lua -->
  - [x] Scope highlighting enabled
  - [x] Exclude filetypes: dashboard, help, terminal

- [x] Task 9: Create lua/config/flash.lua
  <!-- files: lua/config/flash.lua -->
  - [x] s → flash jump (normal + visual)
  - [x] S → treesitter select
  - [x] r → remote flash (operator-pending)

- [x] Task 10: Wire all new configs in lua/init.lua
  <!-- files: lua/init.lua -->
  <!-- depends: task2, task3, task4, task5, task6, task7, task8, task9 -->
  - [x] require each new config module in order

- [x] Task: Conductor - User Manual Verification 'Phase 1: Add Plugins and Wire Configs' (Protocol in workflow.md)

## Phase 2: Build, Install, and Verify

- [x] Task 1: Run task build + task install
- [x] Task 2: Run luacheck — confirm 0 errors/warnings

- [x] Task: Conductor - User Manual Verification 'Phase 2: Build, Install, and Verify' (Protocol in workflow.md)

## Phase 3: Documentation

- [x] Task 1: Update README.md with usage section for all plugins (new + existing)

- [x] Task: Conductor - User Manual Verification 'Phase 3: Documentation' (Protocol in workflow.md)
