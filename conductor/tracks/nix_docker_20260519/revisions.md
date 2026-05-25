# Track Revisions: nix_docker_20260519

## Revision 1 — 2026-05-19

**Type:** Spec + Plan

**Triggered by:** Task 1 (Audit current neovim modules) — discovered that Nix-built binaries
have hard-coded `/nix/store/...` absolute paths in their headers/wrapper scripts. Copying
binaries via `docker cp` to a host without `/nix/store` produces broken executables.

**Phase/Task when discovered:** Phase 1, Task 1

**Changes made:**

- **Spec:** Changed the build strategy from "copy everything including nvim binary and LSPs
  via docker cp" to "Docker/Nix builds only the plugin pack (pure Lua/VimL files); nvim
  binary and all tools (LSPs, formatters) come from Homebrew on the host."
- **Spec:** Added `Brewfile` as a committed dependency list for host tools.
- **Spec:** Updated acceptance criteria to reflect Homebrew-based tools.
- **Plan:** Updated Task 2 derivation design to `packages.nvim-plugin-pack` using `cp -rL`
  of plugin store paths into a `pack/nix/start/` tree.
- **Plan:** Added `Brewfile` creation to Task 3.
- **Plan:** Updated `task install` (Phase 2, Task 2) to handle Lua config symlinking.
- **Plan:** Added `task brew-install` to Phase 4.

**Rationale:** Keeping a completely clean host (`no /nix` at all) is only feasible if
the Docker build produces outputs that are relocatable to arbitrary host paths. Pure Lua
plugin files satisfy this; compiled binaries (nvim, LSPs) do not without bundling tricks
that are platform-specific and fragile on macOS.
