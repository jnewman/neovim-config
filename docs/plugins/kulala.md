# kulala.nvim

## Purpose

An in-editor HTTP / GraphQL / gRPC / WebSocket client.
[`mistweaverco/kulala.nvim`](https://github.com/mistweaverco/kulala.nvim)
implements the JetBrains `.http` spec (with scripting support), so you write
requests in a plain `.http` or `.rest` file and send them without leaving Neovim.
Responses open in a split next to the request. The requests themselves are
executed by a bundled `kulala-core` binary rather than in-process.

## Prerequisites

Both are already present on this host:

- **`curl`** — the transport `kulala-core` shells out to.
- **`tree-sitter`** CLI — kulala self-manages the `http` tree-sitter parser and
  queries (download/build) for syntax highlighting and request navigation. If it
  is ever missing, set `treesitter = { enable = false }` in
  `lua/config/kulala.lua` to fall back to kulala's built-in vim syntax.

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
replay / scratchpad / open) are global.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>Rs` | Normal / Visual | Send request under cursor |
| `<CR>` | Normal / Visual | Send request (in `.http`/`.rest` buffers) |
| `<leader>Ra` | Normal / Visual | Send all requests in the file |
| `<leader>Rr` | Normal | Replay the last request |
| `<leader>Rb` | Normal | Open the scratchpad |
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

The `<leader>R` prefix is registered as the **REST/Kulala** group in which-key.
Inside the response window kulala provides its own maps (e.g. `H`/`J` to switch
panes, `[`/`]` for previous/next response, `?` for help, `q` to close).

## Config Notes

- Config lives in `lua/config/kulala.lua`, loaded from `lua/init.lua`.
- `global_keymaps = true` with `global_keymaps_prefix = "<leader>R"` is what
  installs the table above. Setting `global_keymaps = false` disables all of
  them (kulala's window-local maps stay).
- The response opens in a right-hand split (`ui.display_mode = "split"`,
  `split_direction = "right"`, `default_view = "body"`).
- Packaged from nixpkgs (`kulala-nvim`) in `modules/plugins.nix`.
