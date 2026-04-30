# Plan: MVP Foundation — Nix Flake + home-manager Neovim base

**Track ID:** nix_foundation_20260429

---

## Phase 1: Flake Scaffold

- [ ] Task: Create `flake.nix` with nixpkgs (nixos-unstable) and home-manager inputs
- [ ] Task: Add `flake.lock` by running `nix flake update`
- [ ] Task: Define a `devShell` output with stylua and nixfmt available
- [ ] Task: Verify `nix develop` enters the shell without errors
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Flake Scaffold' (Protocol in workflow.md)

---

## Phase 2: home-manager Neovim Module

- [ ] Task: Create a home-manager module (`modules/neovim.nix`) that enables `programs.neovim`
- [ ] Task: Wire the module into a `homeConfigurations` output in `flake.nix`
- [ ] Task: Set `programs.neovim.defaultEditor = true` and `viAlias`/`vimAlias`
- [ ] Task: Verify `home-manager switch` activates without errors
- [ ] Task: Conductor - User Manual Verification 'Phase 2: home-manager Neovim Module' (Protocol in workflow.md)

---

## Phase 3: Base Lua Config

- [ ] Task: Create `lua/config/options.lua` — line numbers, relative numbers, clipboard, tab width (2), termguicolors
- [ ] Task: Create `lua/config/keymaps.lua` — minimal additions only (e.g. clear search highlight)
- [ ] Task: Create `lua/config/autocmds.lua` — highlight on yank, trim trailing whitespace
- [ ] Task: Create `init.lua` that requires the three config modules
- [ ] Task: Wire Lua config into home-manager via `programs.neovim.extraLuaConfig` or `xdg.configFile`
- [ ] Task: Confirm `stylua --check` passes on all Lua files
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Base Lua Config' (Protocol in workflow.md)

---

## Phase 4: Colorscheme

- [ ] Task: Select and add a colorscheme plugin available in nixpkgs (e.g. catppuccin-nvim or tokyonight-nvim)
- [ ] Task: Declare plugin in `programs.neovim.plugins` in the Nix module
- [ ] Task: Apply colorscheme in `init.lua` (both dark and light variants accessible)
- [ ] Task: Verify colorscheme loads without errors on `nvim` launch
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Colorscheme' (Protocol in workflow.md)

---

## Phase 5: Formatting & Linting Gates

- [ ] Task: Add `stylua.toml` to project root with agreed settings (2-space indent, 100 col width)
- [ ] Task: Confirm `nixfmt` available in dev shell and `nix fmt` works
- [ ] Task: Run full format pass; commit clean state
- [ ] Task: Conductor - User Manual Verification 'Phase 5: Formatting & Linting Gates' (Protocol in workflow.md)
