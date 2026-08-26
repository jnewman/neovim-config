# kulala.nvim

## Purpose

An in-editor HTTP / GraphQL / gRPC / WebSocket client.
[`mistweaverco/kulala.nvim`](https://github.com/mistweaverco/kulala.nvim)
implements the JetBrains `.http` spec (with scripting support), so you write
requests in a plain `.http` or `.rest` file and send them without leaving Neovim.
Responses open in a split next to the request. The requests themselves are
executed by a bundled `kulala-core` binary rather than in-process.

## Prerequisites

All three are already present on this host:

- **`curl`** — the transport `kulala-core` shells out to.
- **`tree-sitter`** CLI — kulala self-manages the `http` tree-sitter parser and
  queries (download/build) for syntax highlighting and request navigation. If it
  is ever missing, set `treesitter = { enable = false }` in
  `lua/config/kulala.lua` to fall back to kulala's built-in vim syntax.
- **`yq`** — only needed by the `<leader>Ry` YAML view (see Config Notes).

The `kulala-core` request backend ships with the nix package — no separate
install needed.

## Usage

Open (or create) a file ending in `.http` or `.rest`, write a request, put the
cursor on it, and press `<leader>Rs` (or `<CR>`) to send it. Example:

```http
GET https://httpbin.org/get
Accept: application/json

###

POST https://httpbin.org/post
Content-Type: application/json

{ "hello": "world" }
```

`###` separates requests; `<leader>Rn` / `<leader>Rp` jump between them.

## Keybindings

kulala installs its own keymaps **buffer-locally** under the `<leader>R` (REST)
prefix. Most attach only in `http`/`rest` buffers; a few (send / send-all /
replay / scratchpad / open / show-as-YAML) are global.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>Rs` | Normal / Visual | Send request under cursor |
| `<CR>` | Normal / Visual | Send request (in `.http`/`.rest` buffers) |
| `<leader>Ra` | Normal / Visual | Send all requests in the file |
| `<leader>Rr` | Normal | Replay the last request |
| `<leader>Rb` | Normal | Open the persistent scratchpad file |
| `<leader>Ro` | Normal | Open the kulala output window |
| `<leader>Rq` | Normal | Close the kulala window |
| `<leader>Rt` | Normal | Toggle headers / body view |
| `<leader>Ri` | Normal | Inspect the current request |
| `<leader>Rn` | Normal | Jump to next request |
| `<leader>Rp` | Normal | Jump to previous request |
| `<leader>Rf` | Normal | Find a request (picker) |
| `<leader>Re` | Normal | Select environment |
| `<leader>Rc` | Normal | Copy request as cURL |
| `<leader>RC` | Normal | Paste a cURL command as a request |
| `<leader>Rj` | Normal | Open the cookies jar |
| `<leader>Ru` | Normal | Manage auth config |
| `<leader>Rg` | Normal | Download GraphQL schema |
| `<leader>RS` | Normal | Show request stats |
| `<leader>Rx` | Normal | Clear script global variables |
| `<leader>RX` | Normal | Clear cached files |
| `<leader>Ry` | Normal | Show the last response body as YAML |

The `<leader>R` prefix is registered as the **REST/Kulala** group in which-key.
Inside the response window kulala provides its own maps (e.g. `H`/`J` to switch
panes, `[`/`]` for previous/next response, `?` for help, `q` to close).

## Config Notes

- Config lives in `lua/config/kulala.lua`, loaded from `lua/init.lua`.
- `global_keymaps` with `global_keymaps_prefix = "<leader>R"` is what installs
  the table above. It is set to a table holding the `<leader>Ry` and
  `<leader>Rb` entries; kulala merges those over its own defaults (by entry
  name), so every other default keymap still applies. Setting
  `global_keymaps = false` disables all of them (kulala's window-local maps
  stay).
- The response opens in a right-hand split (`ui.display_mode = "split"`,
  `split_direction = "right"`, `default_view = "body"`).
- `ui.win_opts.wo.foldlevel = 99` keeps response bodies unfolded. kulala sets
  `foldmethod = "indent"` on that window and leaves `foldlevel` alone, so
  without this every pretty-printed JSON body opens fully collapsed. Normal
  fold keys (`zM`, `za`, `zR`) still work.
- `<leader>Rb` overrides kulala's built-in scratchpad and opens
  `stdpath("data")/kulala-scratchpad.http` instead, seeded with
  `ui.scratchpad_default_contents` the first time. Kulala's own scratchpad is a
  `kulala://scratchpad` buffer that is overwritten with the default contents on
  every open, cannot be `:w`ritten (`E212`), and is deleted on session load — so
  notes never survive. The replacement is an ordinary file: save it with `:w`,
  and the `.http` extension keeps every `<leader>R` keymap attached. Remove the
  `Open scratchpad` entry from `global_keymaps` to get the built-in back.
- `<leader>Ry` converts the last response body to YAML with `yq` and opens it in
  a read-only scratch split below the response window (`q` closes it). This is a
  local helper, not a kulala feature: as of 6.29.0 response formatting happens in
  `kulala-core` (`response_format`), and the `contenttypes.formatter` hook the
  bundled help still documents is no longer applied when rendering a response —
  only `pathresolver` is, for request variables. Requires `yq` on PATH.
- Packaged from nixpkgs (`kulala-nvim`) in `modules/plugins.nix`.
