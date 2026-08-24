# neorepl.nvim

## Purpose

An in-editor REPL for evaluating Lua or Vimscript, with buffer/window context
switching so expressions can run against another buffer.

## Keybindings / Commands

| Command | Action |
|---------|--------|
| `:Repl` | Open a new REPL instance (starts in Lua mode) |
| `:Repl vim` | Open a REPL instance in Vimscript mode |

Inside the REPL, type `/h` and enter to see its own commands (`/lua`, `/vim`,
`/b`, `/w`, etc.).

## Config Notes

Zero-config: `:Repl` is registered automatically once installed, so there's
no `lua/config/neorepl.lua` — nothing to call.
