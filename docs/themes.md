# Theme pairs

Core, non-plugin colorscheme config set in
[`lua/config/colorscheme.lua`](../lua/config/colorscheme.lua).

Three named **pairs**, each holding a day and a night colorscheme. The OS
light/dark setting picks the slot; `<leader>tt` picks the pair.

| Pair | Day | Night |
|------|-----|-------|
| `earthy` | [belafonte-day](plugins/belafonte-day.md) | [melange](plugins/melange.md) |
| `cyber` | [fairyfloss](plugins/fairyfloss.md) | [tokyonight](plugins/tokyonight.md) (Moon) |
| `emerald` | [django](plugins/django.md) | [django-reborn-again](plugins/django-reborn-again.md) |

Each pair mirrors a Ghostty `theme = light:...,dark:...` line, so the editor
matches the surrounding terminal.

> **"Day" is the pair member, not the luminance.** Only `earthy` is a genuine
> light/dark pair. fairyfloss (`#5a5475`) and both django themes are
> dark-background themes that happen to sit in day slots.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Cycle to the next pair (`earthy` → `cyber` → `emerald`) |

The active pair is written to `stdpath("state")/theme-pair.txt` and restored on
next launch. Delete that file to reset to `earthy`.

## How the day/night switch works

Because four of the six themes are dark-background, the terminal's reported
background colour cannot tell the two slots apart. The **OS appearance setting**
is used instead:

| Platform | Source |
|---|---|
| Linux | XDG desktop portal — `org.freedesktop.appearance` / `color-scheme` |
| macOS | `defaults read -g AppleInterfaceStyle` |

The portal is used rather than `gsettings` because it is desktop-agnostic;
COSMIC ships no `gsettings` schemas. Portal values are `0` (no preference),
`1` (prefer dark), `2` (prefer light).

Check it by hand with:

```sh
gdbus call --session --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop \
  --method org.freedesktop.portal.Settings.ReadOne \
  org.freedesktop.appearance color-scheme
```

Changes arrive by **subscription**, not polling: one `gdbus monitor` job starts
at `VimEnter` and is killed at `VimLeavePre`, so flipping the OS theme repaints
Neovim without any keypress. The signal is only a trigger — its payload is never
parsed, and the value always comes from a fresh query. On macOS, or on a host
without `gdbus`, the check runs on `FocusGained` instead.

## Config notes

- `lua/config/colorscheme.lua` **assigns** `'background'` from each theme's
  declared luminance before calling `:colorscheme`. melange and tokyonight both
  read `'background'`, and the terminal reports `dark` for the fairyfloss and
  django slots, so it cannot be left to the terminal.
- Order matters: assigning `'background'` makes Neovim reload the active
  colorscheme, so it has to happen *before* the `:colorscheme` call.
- The four themes with no upstream Neovim plugin live in `colors/` and generate
  their highlight groups with
  [mini.base16](https://github.com/nvim-mini/mini.base16). `task install`
  symlinks `colors/` into `~/.config/nvim`.
