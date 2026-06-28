# agentic-nvim

## Purpose

In-editor AI agent chat. [`carlos-algms/agentic.nvim`](https://github.com/carlos-algms/agentic.nvim)
is an Agent Client Protocol (ACP) client: it spawns an external agent CLI, speaks
ACP to it over stdio, and renders the conversation in a sidebar with permission
prompts, context attachment, and session restore. This config defaults to the
**Claude Agent ACP** provider so it pairs with the `claude` toolchain already in use.

## Prerequisite

The plugin does **not** bundle any agent binary (by design). Install the Claude ACP
CLI on `PATH` before first use:

```bash
npm i -g @agentclientprotocol/claude-agent-acp
# or: pnpm add -g @agentclientprotocol/claude-agent-acp
```

The provider key `claude-agent-acp` spawns the `claude-agent-acp` command. Unlike
octo.nvim's hard `gh` gate, a missing CLI does **not** abort `init.lua` — the error
only surfaces when you open a session. Optional clipboard-image paste needs
`wl-clipboard` (Wayland) or `xclip` (X11).

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<C-\>` | Normal / Visual / Insert | Toggle the chat sidebar |
| `<leader>aa` | Normal | Toggle chat |
| `<leader>an` | Normal | New session |
| `<leader>ar` | Normal | Restore previous session |
| `<leader>ap` | Normal | Switch ACP provider |
| `<leader>af` | Normal | Add current file to context |
| `<leader>ac` | Normal / Visual | Add selection (or file) to context |
| `<leader>ad` | Normal | Add buffer diagnostics to context |

The `<leader>a` prefix is registered as the **AI/Agent** group in which-key.
Inside the chat buffer the plugin provides its own maps (`<CR>`/`<C-s>` submit,
`<S-Tab>` switch mode, `<localLeader>m` switch model, `q` close).

## Config Notes

- `provider = "claude-agent-acp"` — sets the default ACP backend. Other providers
  (`gemini-acp`, `codex-acp`, `copilot-acp`, …) ship in the plugin's defaults and
  can be switched mid-session with `<leader>ap`.
- Packaged from a flake source input (`agentic-nvim-src` in `flake.nix`), not from
  nixpkgs, and built with `buildVimPlugin` in `modules/plugins.nix`. The build's
  nvim require-check is disabled (`doCheck = false`) because the plugin bundles
  `*.test` modules that need a test harness absent at build time.
- Requires Neovim ≥ 0.11 (host runs 0.12.x).
- Config lives in `lua/config/agentic.lua`, loaded from `lua/init.lua`.
