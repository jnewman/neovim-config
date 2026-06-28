# Spec: Agentic Dev Tools (agentic.nvim)

> Status: **APPROVED — implementing** (spec-driven-development)
> Created: 2026-06-28

## Objective

Add in-editor AI agent tooling to this Neovim config, packaged the same
reproducible, Nix-built way as every other plugin in the pack.

**agentic.nvim** — [`carlos-algms/agentic.nvim`](https://github.com/carlos-algms/agentic.nvim).
A Lua ACP (Agent Client Protocol) chat client. Talks to external agent CLIs
(Claude, Gemini, Codex, Copilot CLI, …) over ACP and renders the conversation
in a sidebar.

> copilot-agent.nvim was originally requested too but has been **dropped from
> scope** (no GitHub Copilot subscription); not tracked further.

**Who is the user:** the repo owner (single-user Neovim config, Nix-managed pack,
nvim runs natively on the host).

**Success looks like:** `:lua require("agentic").toggle()` (and its keybind) opens
a working Claude-backed agent chat in Neovim after `task rebuild`, with no
runtime binary downloads and no regressions to existing plugins.

## Tech Stack

- **Plugin manager:** none in the Lua sense — plugins are copied into a Nix-built
  pack (`pack/nix/start/*`) by `modules/plugins.nix`; `lua/init.lua` `require`s a
  per-plugin config module. There is **no lazy.nvim**, so upstream
  `{ "owner/repo", opts = {...} }` snippets must be translated to a
  `require("plugin").setup({...})` call.
- **Packaging:** Nix flake. Plugins not in `nixpkgs.vimPlugins` are added as
  `flake = false` inputs and copied with `cp -rL`, exactly like `octo-nvim-src`
  (see `flake.nix` + `modules/plugins.nix`).
- **Host (verified):** Neovim 0.12.3 (✓ ≥0.11 for agentic), Node 24, Go 1.26,
  `claude` CLI 2.1.178 all present.
- **agentic.nvim runtime dep:** an ACP provider CLI. Default provider:
  `claude-agent-acp`, installed via npm/pnpm:
  `npm i -g @agentclientprotocol/claude-agent-acp` (Node-based).
- **Neither plugin is in nixpkgs** — confirmed by querying
  `nixpkgs.vimPlugins` (only `CopilotChat-nvim`, `avante-nvim`, `codecompanion-nvim`,
  `copilot-lua`, etc. exist).

## Commands

```bash
# Build the plugin pack (native Nix on this host)
task build              # nix build .#nvim-plugin-pack

# Install pack + wire config symlinks
task install

# Do both, plus LSP tooling
task rebuild

# Update flake inputs (picks up new agentic-nvim-src input + lock)
task update            # nix flake update

# Quality gates
task fmt               # stylua + nixfmt
task lint              # stylua --check + nixfmt --check
task test              # luacheck lua/
```

## Project Structure

Files this spec touches:

```
flake.nix                      → add `agentic-nvim-src` flake input, thread into plugins.nix
modules/plugins.nix            → add agentic-nvim entry (pkg built from the src input)
lua/config/agentic.lua         → NEW: require("agentic").setup({...}) + keymaps
lua/init.lua                   → add require("config.agentic")
lua/config/which-key.lua       → add `<leader>a` = "AI/Agent" group
docs/plugins/agentic.md        → NEW: plugin doc (Purpose / Keybindings / Config Notes)
docs/specs/agentic-dev-tools.md→ THIS spec (kept in version control)
```

## Code Style

Match existing per-plugin config modules (see `lua/config/octo.lua`,
`lua/config/flash.lua`): a top-level `setup()` call, then `local map =
vim.keymap.set`, then grouped `map(...)` calls with `{ desc = "..." }`.
Two-space indent, double-quoted strings (enforced by `stylua.toml`).

```lua
-- lua/config/agentic.lua  (illustrative shape, exact opts verified at impl time)
require("agentic").setup({
  provider = "claude-agent-acp",
})

local map = vim.keymap.set

map({ "n", "v", "i" }, "<C-\\>", function()
  require("agentic").toggle()
end, { desc = "Toggle Agentic chat" })

map("n", "<leader>an", function()
  require("agentic").new_session()
end, { desc = "New agent session" })

map("v", "<leader>aa", function()
  require("agentic").add_selection_or_file_to_context()
end, { desc = "Add selection/file to context" })
```

Nix entries in `modules/plugins.nix` follow the existing `{ name = ...; pkg =
...; }` list shape. The flake input mirrors `octo-nvim-src`:

```nix
agentic-nvim-src = {
  url = "github:carlos-algms/agentic.nvim";
  flake = false;
};
```

`modules/plugins.nix` receives it as a function arg (alongside `octo-nvim-src`)
and builds the pkg via `pkgs.vimUtils.buildVimPlugin` (or a `runCommand` copy if
buildVimPlugin chokes on the repo layout).

## Testing Strategy

This repo has **no automated plugin-load tests** — `task test` runs `luacheck`
only; plugin loading is verified manually on the host after `task install`
(per `Taskfile.yml` comment). Accordingly:

1. **Static:** `task lint` (stylua + nixfmt clean) and `task test` (luacheck clean,
   no globals violations against `.luacheckrc`).
2. **Build:** `task build` succeeds — agentic source resolves and copies into the
   pack.
3. **Load smoke test:** `nvim --headless "+lua require('agentic')" +qa` exits 0
   (module loads without error). Then `+lua require('agentic').toggle()` opens the
   widget interactively.
4. **Functional (manual):** with `@agentclientprotocol/claude-agent-acp` on PATH,
   `<C-\>` opens the chat, a prompt round-trips a response from Claude.
5. **Regression:** existing plugins still load (open a Lua + Markdown file, confirm
   no `init.lua` errors).

## Boundaries

- **Always:** run `task fmt` then `task lint`/`task test` before committing;
  follow the `{ name; pkg; }` and `require("config.X")` conventions; keep the
  spec + docs updated; track work in `bd` (not TodoWrite/markdown).
- **Ask first:** changing the install/rebuild Taskfile flow; adding a hard
  `command -v` gate that aborts `init.lua` (octo does this for `gh` — agentic
  should NOT, since the ACP CLI is only needed at use-time); pinning/overriding
  the agentic source revision; adding the ACP CLI to `Brewfile`/`lsp-tools`.
- **Never:** download binaries at runtime into the pack (the whole point of the
  Nix build); commit secrets or API keys; remove or weaken existing plugin
  configs.

## Implementation Plan (for review)

Sequenced; each step verifiable.

1. **Flake input** — add `agentic-nvim-src` to `flake.nix` inputs and the
   `outputs` arg list; thread it into both `import ./modules/plugins.nix` calls.
   Run `task update` (or `nix flake lock`) to populate `flake.lock`.
   *Verify:* `flake.lock` gains the input; `nix flake metadata` lists it.
2. **Pack entry** — accept `agentic-nvim-src` in `modules/plugins.nix`, build the
   pkg, add `{ name = "agentic-nvim"; pkg = ...; }` to the list.
   *Verify:* `task build` succeeds; `result/pack/nix/start/agentic-nvim/` exists.
3. **Lua config** — create `lua/config/agentic.lua` with the verified `setup()`
   opts (provider `claude-agent-acp`) + keymaps; add `require("config.agentic")`
   to `lua/init.lua`; add the `<leader>a` group to `which-key.lua`.
   *Verify:* `task test` (luacheck) clean.
4. **Install + smoke test** — `task install`; run the headless load smoke test
   and interactive toggle.
   *Verify:* module loads, widget opens, existing plugins unaffected.
5. **Docs** — add `docs/plugins/agentic.md`; note the
   `@agentclientprotocol/claude-agent-acp` install step in the doc (and README if
   appropriate).
   *Verify:* doc matches actual keybindings/opts.

## Success Criteria

- [ ] `task build` and `task rebuild` succeed with the new input.
- [ ] `flake.lock` pins `agentic-nvim-src`; build is reproducible (no network at
      nvim runtime).
- [ ] `nvim --headless "+lua require('agentic')" +qa` exits 0.
- [ ] `<C-\>` (and `<leader>a*` maps) open/drive the agent chat; with the ACP CLI
      installed, a prompt round-trips a Claude response.
- [ ] `task lint` and `task test` pass; `which-key` shows the `AI/Agent` group.
- [ ] No regression: all previously-loaded plugins still load cleanly.
- [ ] `docs/plugins/agentic.md` documents purpose, keybindings, and the ACP CLI
      prerequisite.

## Open Questions

1. **Exact agentic provider command.** README states provider key
   `claude-agent-acp` invokes the `claude` ACP CLI, while install docs point to the
   `@agentclientprotocol/claude-agent-acp` npm package. To be confirmed at impl
   time which binary the provider actually spawns (and whether the installed
   `claude` 2.1 already speaks ACP, making the npm package unnecessary).
2. **buildVimPlugin vs runCommand copy.** Prefer `pkgs.vimUtils.buildVimPlugin`;
   fall back to a `cp -rL` `runCommand` (octo style) if the repo layout or a
   build step (e.g. bundled JS) causes issues. Decide during step 2.
3. **ACP CLI distribution.** Leave the `@agentclientprotocol/claude-agent-acp`
   install as a documented manual step, or wire it into `Brewfile`/`lsp-tools`?
   Default: document only (it's an npm global, not a brew/nix-profile fit).
   (Listed under "Ask first".)
4. **Keymap surface.** Proposed `<C-\>` toggle + `<leader>a` group. Confirm the
   `<leader>a` namespace and which actions to bind.
```
