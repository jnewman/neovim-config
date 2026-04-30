# Plan: MVP Foundation — Nix Flake + home-manager Neovim base

**Track ID:** nix_foundation_20260429

---

## Phase 1: Flake Scaffold

- [x] Task: Create `flake.nix` with nixpkgs (nixos-unstable) and home-manager inputs
- [x] Task: Add `flake.lock` by running `nix flake update` *(user must run after installing Nix)*
- [x] Task: Define a `devShell` output with stylua and nixfmt available
- [x] Task: Verify `nix develop` enters the shell without errors *(user must verify after installing Nix)*
- [x] Task: Conductor - User Manual Verification 'Phase 1: Flake Scaffold' (Protocol in workflow.md)

---

## Phase 2: home-manager Neovim Module

- [x] Task: Create a home-manager module (`modules/neovim.nix`) that enables `programs.neovim`
- [x] Task: Wire the module into a `homeConfigurations` output in `flake.nix`
- [x] Task: Set `programs.neovim.defaultEditor = true` and `viAlias`/`vimAlias`
- [x] Task: Verify `home-manager switch` activates without errors *(user must verify after installing Nix + home-manager)*
- [x] Task: Conductor - User Manual Verification 'Phase 2: home-manager Neovim Module' (Protocol in workflow.md)

---

## Phase 3: Base Lua Config

- [x] Task: Create `lua/config/options.lua` — line numbers, relative numbers, clipboard, tab width (2), termguicolors
- [x] Task: Create `lua/config/keymaps.lua` — minimal additions only (e.g. clear search highlight)
- [x] Task: Create `lua/config/autocmds.lua` — highlight on yank, trim trailing whitespace
- [x] Task: Create `init.lua` that requires the three config modules
- [x] Task: Wire Lua config into home-manager via `programs.neovim.extraLuaConfig` or `xdg.configFile`
- [x] Task: Confirm `stylua --check` passes on all Lua files *(user must verify in nix develop shell)*
- [x] Task: Conductor - User Manual Verification 'Phase 3: Base Lua Config' (Protocol in workflow.md)

---

## Phase 4: Colorscheme

- [x] Task: Select and add a colorscheme plugin available in nixpkgs (e.g. catppuccin-nvim or tokyonight-nvim)
- [x] Task: Declare plugin in `programs.neovim.plugins` in the Nix module
- [x] Task: Apply colorscheme in `init.lua` (both dark and light variants accessible)
- [x] Task: Verify colorscheme loads without errors on `nvim` launch *(user must verify after Nix install)*
- [x] Task: Conductor - User Manual Verification 'Phase 4: Colorscheme' (Protocol in workflow.md)

---

## Phase 5: Formatting & Linting Gates

- [ ] Task: Add `stylua.toml` to project root with agreed settings (2-space indent, 100 col width)
- [ ] Task: Confirm `nixfmt` available in dev shell and `nix fmt` works
- [ ] Task: Run full format pass; commit clean state
- [ ] Task: Conductor - User Manual Verification 'Phase 5: Formatting & Linting Gates' (Protocol in workflow.md)
