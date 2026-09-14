# Spec: Package the config as a self-contained Nix flake

## Objective

Turn this repo into a flake that **builds a ready-to-run Neovim** — plugins,
Lua config, colorschemes, tree-sitter parsers, and all language tooling bundled
into one wrapped `nvim` binary — installed via `nix profile install` / run via
`nix run`.

Today the flake only builds a plugin *pack* and an `lsp-tools` bundle; a separate
`task install` step **copies** the pack into `~/.local/share/nvim` and
**symlinks** `init.lua`/`lua/`/`colors/` into `~/.config/nvim`, and the editor
binary comes from the host. We are replacing that symlink/copy install with a
proper flake package.

**Who:** Josh, on a nix host (Linux, `nix` available). Non-nix hosts are no
longer supported.

**Success looks like:** `nix run github:jnewman/neovim-config` launches a fully
working editor — LSP, formatting, tree-sitter highlighting, mermaid preview, octo
— with **nothing** symlinked into `~/.config/nvim` and **no** Docker, Homebrew,
or `task install` involved.

## Tech Stack

- Nix flakes (`nixpkgs` unstable, already pinned in `flake.lock`).
- `pkgs.wrapNeovimUnstable` + `pkgs.neovimUtils.makeNeovimConfig` to wrap nvim.
- `pkgs.vimPlugins.nvim-treesitter.withPlugins` for prebuilt parsers (verified
  present in the pinned nixpkgs).
- Existing `modules/plugins.nix` (plugin set) and `modules/lsp-tools.nix`
  (servers + formatters) as inputs, refactored into the wrapper.
- Lua config unchanged in structure (`lua/init.lua`, `lua/config/*`, `colors/*`).

## Commands

```
Build package:   nix build .#            # -> ./result/bin/nvim
Run:             nix run .#              # launches wrapped nvim
Install:         nix profile install .#
Format:          nix develop -c sh -c 'stylua . && nixfmt flake.nix modules/*.nix'
Lint:            nix develop -c sh -c 'stylua --check . && nixfmt --check flake.nix modules/*.nix'
Test:            nix develop -c sh -c 'luacheck lua/ colors/ && actionlint'
Smoke test:      nix run .# -- --headless '+lua vim.cmd("checkhealth")' +qa
```

## Project Structure

```
flake.nix                 → outputs: packages.default (wrapped nvim), apps.default,
                            packages.lsp-tools (kept, reused by the wrapper), devShells
modules/
  neovim.nix     (NEW)    → wrapNeovimUnstable assembly: plugins + config + parsers +
                            runtime PATH -> the final nvim package
  config.nix     (NEW)    → derivation packaging lua/ + colors/ + the init require-chain
                            as one vim plugin dir on runtimepath
  plugins.nix    (EDIT)   → returns the *list* of plugin derivations (drop the
                            runCommand pack-dir wrapper; the wrapper consumes the list)
  lsp-tools.nix  (KEEP)   → unchanged; consumed by neovim.nix for the wrapper PATH
lua/, colors/             → unchanged
docs/                     → update install/usage docs to the flake workflow
```

Removed: `Taskfile.yml` Docker branches, `Dockerfile`, `scripts/lsp-start.sh`,
`scripts/nix-run.sh`, `config/nvim-lsp.plist`, `config/nvim-lsp.service`,
`Brewfile`. (See Boundaries — deletions are "ask first".)

## Code Style

Nix follows the existing `nixfmt` style in `modules/*.nix`. The wrapper reads:

```nix
# modules/neovim.nix
{ pkgs, plugins, lspTools, configPlugin }:
let
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
    plugins = plugins ++ [ configPlugin ];   # each: { plugin = drv; }
  };
  # Everything the config shells out to at runtime, on the wrapper's PATH.
  runtimeDeps = [ lspTools pkgs.gh pkgs.curl pkgs.imagemagick pkgs.mermaid-cli pkgs.glib ];
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig // {
  wrapperArgs = neovimConfig.wrapperArgs ++ [
    "--suffix" "PATH" ":" (pkgs.lib.makeBinPath runtimeDeps)
    "--set" "NVIM_TOOLS_NATIVE" "1"
  ];
})
```

The config plugin (`modules/config.nix`) exposes `lua/` and `colors/` on
runtimepath and auto-sources the require-chain from `lua/init.lua`:

```nix
pkgs.vimUtils.buildVimPlugin {
  pname = "jnewman-nvim-config";
  version = "1";
  src = ../.;                      # or a filtered source of lua/ + colors/
  # init.lua's require-chain runs at startup once packpath plugins are loaded:
  postInstall = ''
    mkdir -p $out/plugin
    cp $out/lua/init.lua $out/plugin/zzz-jnewman-config.lua
  '';
  doCheck = false;
}
```

## Testing Strategy

No unit-test framework exists; verification is build + smoke-test + manual:

1. **Build:** `nix build .#` succeeds; `./result/bin/nvim --version` runs.
2. **Headless health:** `nix run .# -- --headless '+checkhealth' +qa` shows no
   missing-runtime-dependency errors for treesitter, mason-free LSP, image.nvim.
3. **Parsers present:** `nix run .# -- --headless '+lua =vim.treesitter.language.add("go")' +qa`
   loads a bundled parser without compiling.
4. **LSP native:** open a `.go`/`.py`/`.lua` file, confirm the server attaches
   (server binaries resolved from the wrapper PATH, not Docker).
5. **Manual sweep:** theme cycle (`<leader>tt`), format-on-save, octo (`gh` on
   PATH), mermaid preview, kulala.
6. **Purity:** `nix run` works with `~/.config/nvim` and `~/.local/share/nvim`
   absent/empty (only writable state — sessions, parser cache if any — created).
7. Keep `luacheck` + `actionlint` green.

## Boundaries

- **Always:** run `luacheck`/`stylua --check`/`nixfmt --check` before finishing;
  keep `docs/` in sync with config in the same change (per CLAUDE.md); build the
  package and smoke-test headless before declaring a task done.
- **Ask first:** deleting the Docker/Homebrew/symlink machinery (Dockerfile,
  Taskfile, scripts, plist/service, Brewfile); bumping/altering `flake.lock`
  inputs; changing which language servers or parsers are bundled.
- **Never:** commit `.beads/` artifacts; commit secrets; silently change editor
  behavior (keymaps, enabled plugins) while doing the packaging refactor.

## Success Criteria

1. `nix build .#` produces `./result/bin/nvim`; `packages.default` and
   `apps.default` are defined for the four systems already listed in `flake.nix`.
2. Launching the built `nvim` with **no** files under `~/.config/nvim` yields the
   same editor experience as today's symlinked install (plugins load, config
   applies, colorschemes available).
3. Tree-sitter highlighting works on first launch for every filetype in
   `treesitter.lua`'s `ensure_installed` **without** `:TSInstall` or a compiler
   at runtime.
4. All language servers and formatters in `lsp-tools.nix` attach/run natively
   from the wrapper PATH; **no** `docker exec` code path remains in `lsp.lua` or
   `format.lua`.
5. Docker/Homebrew/symlink install machinery is removed; `README.md` and `docs/`
   describe only the flake workflow.
6. `luacheck lua/ colors/`, `stylua --check .`, `nixfmt --check`, and
   `actionlint` all pass.

## Open Questions / Risks

1. **`nvim-treesitter` is the `main`-branch rewrite** (CONFIRMED — pinned nixpkgs
   ships `0.10.0-unstable-2026-08-29`, structure has `config.lua`/`install.lua`/
   `parsers.lua`, no classic `configs.lua`). Consequences:
   - `setup()` only accepts `{ install_dir }`. The current `treesitter.lua`'s
     `highlight`/`indent`/`ensure_installed` are **silently ignored** — no
     `vim.treesitter.start()` exists in the repo, so TS highlighting is not
     actually activated by this config today (regression from the ~2026-09-04
     lock bump that flipped nvim-treesitter master→main). **`treesitter.lua`
     must be ported to the main-branch API** (point `install_dir` at bundled
     parsers; enable highlight via a `FileType` autocmd calling
     `vim.treesitter.start()`; set `indentexpr` for indent). This is a fix, not a
     preference change, and is required to meet Success Criterion #3.
   - **`withPlugins`/`withAllGrammars` is a no-op on this package** (returns the
     identical store path — CONFIRMED). Parser bundling must be assembled
     manually: build `parser/<lang>.so` from `pkgs.vimPlugins.nvim-treesitter.builtGrammars`
     (or `pkgs.tree-sitter-grammars.tree-sitter-<lang>`) plus the matching
     queries from the plugin's `runtime/queries/<lang>/`, into a plugin dir on
     rtp. **This is the hardest sub-task — sequenced as a spike first in the Plan.**
2. **`image.nvim` backend.** May require the `magick` LuaRock
   (`luajitPackages.magick`, present in nixpkgs) in addition to the ImageMagick
   CLI. Verify in `:checkhealth image`.
3. **Native-vs-tools detection — DECIDED.** Remove the `use_docker`/`docker exec`
   branches from `lsp.lua`/`format.lua` entirely; always run native binary names
   (Docker is dropped). No env-var flag needed.
4. **Writable state.** nvim writes to `stdpath('state')`/`stdpath('data')`
   (theme-pair.txt, resession sessions, notify history). Confirm nothing assumes
   a writable *config* dir.
5. **`nvimSkipModules`/require-checks** for the two source-input plugins (agentic,
   notion) already handled in `plugins.nix`; keep those overrides when moving to a
   list.
```
