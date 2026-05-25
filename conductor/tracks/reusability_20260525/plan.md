# Plan: Make Config More Reusable

## Phase 1: Taskfile Path Fixes & Idempotency
<!-- execution: sequential -->
<!-- depends: -->

- [ ] Task 1: Replace `~` with `$HOME` in Taskfile.yml
  <!-- files: Taskfile.yml -->

- [ ] Task 2: Harden `install` task for safe re-runs
  — Add guards so re-running `task setup` is safe: check if symlinks are already correct
  before removing and re-creating; handle missing `nvim-build` container gracefully
  <!-- files: Taskfile.yml -->
  <!-- depends: task1 -->

- [ ] Task: Conductor - User Manual Verification 'Taskfile Path Fixes & Idempotency' (Protocol in workflow.md)

## Phase 2: README Restructure & Plugin Docs
<!-- execution: parallel -->
<!-- depends: -->

- [ ] Task 1: Create `docs/plugins/` with one .md per plugin
  — One file per plugin (18 total): purpose snippet, keybindings table, config notes
  Plugins: catppuccin, cyberdream, tokyonight, treesitter, blink-cmp, conform, autopairs,
  comment, oil, which-key, lualine, ibl, flash, telescope, plenary, gitsigns, diffview, octo
  <!-- files: docs/plugins/catppuccin.md, docs/plugins/cyberdream.md, docs/plugins/tokyonight.md, docs/plugins/treesitter.md, docs/plugins/blink-cmp.md, docs/plugins/conform.md, docs/plugins/autopairs.md, docs/plugins/comment.md, docs/plugins/oil.md, docs/plugins/which-key.md, docs/plugins/lualine.md, docs/plugins/ibl.md, docs/plugins/flash.md, docs/plugins/telescope.md, docs/plugins/plenary.md, docs/plugins/gitsigns.md, docs/plugins/diffview.md, docs/plugins/octo.md -->

- [ ] Task 2: Create `docs/README.md` index
  — Index page linking to each plugin doc; intro sentence about the docs directory
  <!-- files: docs/README.md -->

- [ ] Task 3: Rewrite README.md to minimal format
  — Description (1-2 sentences), prerequisites with go-task one-liners for Mac and Linux,
  `task setup` quickstart, link to `docs/`; target ≤ 50 lines
  <!-- files: README.md -->

- [ ] Task: Conductor - User Manual Verification 'README Restructure & Plugin Docs' (Protocol in workflow.md)
