# Plan: Add YAML and JSON Highlighting Support

## Phase 1: Dependencies
<!-- execution: parallel -->

- [x] Task 1: Add `schemastore.nvim` to `modules/plugins.nix`
  <!-- files: modules/plugins.nix -->
  - Sub-task: Add `pkgs.vimPlugins.SchemaStore-nvim` (or fetchFromGitHub) to plugins list
  - Sub-task: Rebuild plugin pack (`task build`)

- [x] Task 2: Add LSP servers and yq to `Brewfile`
  <!-- files: Brewfile -->
  - Sub-task: Add `brew "yaml-language-server"`
  - Sub-task: Add `brew "vscode-json-languageserver"`
  - Sub-task: Add `brew "yq"`
  - Sub-task: Run `brew bundle` to install

- [x] Task: Conductor - User Manual Verification 'Phase 1: Dependencies' (Protocol in workflow.md)

## Phase 2: Treesitter Parsers

- [x] Task 1: Enable yaml and json parsers in Treesitter config
  - Sub-task: Add `"yaml"` and `"json"` to `ensure_installed` list in `lua/plugins/treesitter.lua`

- [x] Task: Conductor - User Manual Verification 'Phase 2: Treesitter Parsers' (Protocol in workflow.md)

## Phase 3: LSP Configuration

- [x] Task 1: Configure yaml-language-server with SchemaStore
  - Sub-task: Add lspconfig setup for `yamlls` in `lua/plugins/lsp.lua`
  - Sub-task: Wire `schemastore.yaml.schemas()` into yamlls settings

- [x] Task 2: Configure jsonls with SchemaStore
  - Sub-task: Add lspconfig setup for `jsonls` in `lua/plugins/lsp.lua`
  - Sub-task: Wire `schemastore.json.schemas()` with `validate.enable = true`

- [x] Task: Conductor - User Manual Verification 'Phase 3: LSP Configuration' (Protocol in workflow.md)

## Phase 4: Formatter Integration

- [x] Task 1: Register yq as formatter in conform.nvim
  - Sub-task: Add `yaml` and `json` entries pointing to `yq` in `lua/plugins/conform.lua`
  - Sub-task: Verify yq formatter spec (conform has built-in support or needs custom definition)

- [x] Task 2: Add format keymap for YAML and JSON buffers
  - Sub-task: Check if a global `<leader>cf` format keymap already exists
  - Sub-task: Add filetype-specific autocmd or ensure global keymap covers these filetypes

- [x] Task: Conductor - User Manual Verification 'Phase 4: Formatter Integration' (Protocol in workflow.md)
