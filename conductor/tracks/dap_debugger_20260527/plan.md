# Plan: Multi-Language DAP Debugger Support

## Phase 1: Plugin & Base Setup
<!-- depends: -->

- [ ] Task 1: Add nvim-dap and nvim-dap-ui to modules/plugins.nix, rebuild Nix pack
  <!-- files: modules/plugins.nix -->

- [ ] Task 2: Create lua/config/dap.lua — skeleton with nvim-dap-ui auto-open/close on
  session start/end, and all keymaps (<leader>db, <leader>dc, <leader>du, F5, F10, F11, F12)
  <!-- files: lua/config/dap.lua -->

- [ ] Task 3: Require dap module in lua/init.lua
  <!-- files: lua/init.lua -->

- [ ] Task 4: Conductor - User Manual Verification 'Plugin & Base Setup' (Protocol in workflow.md)

---

## Phase 2: Dockerfile — Debug Adapter Installation
<!-- depends: -->
<!-- execution: parallel -->

- [ ] Task 1: Add codelldb binary download + extraction (shared by Rust and C)
  <!-- files: Dockerfile -->

- [ ] Task 2: Add debugpy via pip install (Python)
  <!-- files: Dockerfile -->

- [ ] Task 3: Add vscode-js-debug via npm (TypeScript + HTML)
  <!-- files: Dockerfile -->

- [ ] Task 4: Add delve (dlv) via go install (Go)
  <!-- files: Dockerfile -->

- [ ] Task 5: Add rdbg via gem install debug (Ruby)
  <!-- files: Dockerfile -->

- [ ] Task 6: Add haskell-debug-adapter via cabal install (Haskell, best-effort)
  <!-- files: Dockerfile -->

- [ ] Task 7: Add bash-debug via npm install bash-debug (Bash, best-effort)
  <!-- files: Dockerfile -->

- [ ] Task 8: Rebuild container image and verify all adapter binaries are present
  <!-- depends: task1, task2, task3, task4, task5, task6, task7 -->
  <!-- files: Dockerfile -->

- [ ] Task 9: Conductor - User Manual Verification 'Dockerfile Updates' (Protocol in workflow.md)

---

## Phase 3: nvim-dap Adapter Configurations
<!-- depends: phase1, phase2 -->
<!-- execution: parallel -->

- [ ] Task 1: Python — debugpy adapter (stdio via docker exec) + launch config (launch file, attach)
  <!-- files: lua/config/dap.lua -->

- [ ] Task 2: Go — delve adapter (dlv dap via docker exec) + launch config (launch file, test)
  <!-- files: lua/config/dap.lua -->

- [ ] Task 3: Rust + C — codelldb adapter (via docker exec) + launch config for each filetype
  <!-- files: lua/config/dap.lua -->

- [ ] Task 4: TypeScript + HTML — vscode-js-debug adapter + launch config (Node.js + Chrome CDP)
  <!-- files: lua/config/dap.lua -->

- [ ] Task 5: Scala — metals built-in DAP adapter (reuses metals connection) + launch config
  <!-- files: lua/config/dap.lua -->

- [ ] Task 6: Ruby — rdbg adapter (via docker exec) + launch config (launch file, attach)
  <!-- files: lua/config/dap.lua -->

- [ ] Task 7: Haskell — haskell-debug-adapter (via docker exec) + launch config (best-effort)
  <!-- files: lua/config/dap.lua -->

- [ ] Task 8: Bash — bash-debug adapter (via docker exec) + launch config (best-effort)
  <!-- files: lua/config/dap.lua -->

- [ ] Task 9: Add explicit no-op comments for XML and HCL explaining no adapter is available
  <!-- files: lua/config/dap.lua -->

- [ ] Task 10: Conductor - User Manual Verification 'Adapter Configurations' (Protocol in workflow.md)

---

## Phase 4: Documentation
<!-- depends: phase3 -->

- [ ] Task 1: Update conductor/tech-stack.md with DAP adapter table (language, adapter, install method)
  <!-- files: conductor/tech-stack.md -->

- [ ] Task 2: Conductor - User Manual Verification 'Documentation' (Protocol in workflow.md)
