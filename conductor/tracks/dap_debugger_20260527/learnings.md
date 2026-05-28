# Track Learnings: dap_debugger_20260527

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is the sole entry point that requires each module in order (from: nix_foundation_20260429)
- All new LSP servers use `vim.lsp.config` + `vim.lsp.enable` (Neovim 0.10+ native API) — DAP follows the same single-file-per-concern pattern but uses nvim-dap's own API (from: yaml_json_20260525)
- LSP `cmd` values use `{ "docker", "exec", "-i", "nvim-lsp", "<binary>", ... }` — DAP adapter `command` fields follow the same pattern (from: yaml_json_20260525)
- Nix module at `modules/neovim.nix` owns all plugin declarations via `programs.neovim.plugins` (from: nix_foundation_20260429)

---

<!-- Learnings from implementation will be appended below -->
