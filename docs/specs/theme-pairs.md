# Spec: Switchable Day/Night Theme Pairs

Status: **Draft — awaiting review** · Branch: `feat/jnewman/sedira-theme` · Date: 2026-08-21

> **Amended 2026-08-28.** The pair list has since grown to five: `emerald`'s day
> slot moved from Django to Django Smooth, and two pairs were added — `black`
> (Chalk / Gruvbox Dark Hard) and `blue` (Blue Dolphin / Hivacruz). The
> mechanism described below is unchanged; see [themes.md](../themes.md) for the
> current list.

## Objective

Replace the current nine-theme cycle with **three named theme pairs**, each
holding a *day* and a *night* colorscheme. Neovim picks the slot from the
**OS appearance setting**; `<leader>tt` cycles the active pair, and that choice
survives restarts.

**User:** the config owner, working in Neovim inside Ghostty on Linux (COSMIC /
Wayland) and macOS.

**Success looks like:** launching Neovim applies the persisted pair's correct
slot for the current OS appearance; flipping the OS between light and dark
repaints Neovim within a second without touching the keyboard; `<leader>tt`
moves to the next pair and reports it; the choice is still there on next launch;
and every colorscheme that is no longer part of a pair is gone from the plugin
pack, the Lua config, and `docs/`.

### The pairs

| Pair id | Slot | Colorscheme | Ghostty theme | `background` |
|---|---|---|---|---|
| `earthy` | day | `belafonte-day` | Belafonte Day | `light` (`#d5ccba`) |
| `earthy` | night | `melange` | Melange Dark | `dark` |
| `cyber` | day | `fairyfloss` | Fairyfloss | `dark` (`#5a5475`) |
| `cyber` | night | `tokyonight-moon` | TokyoNight Moon | `dark` (`#222436`) |
| `emerald` | day | `django` | Django | `dark` (`#0b2f20`) |
| `emerald` | night | `django-reborn-again` | Django Reborn Again | `dark` (`#051f14`) |

`earthy` is the default pair. Note that four of the six themes are
dark-background regardless of slot — day/night is the *pair member*, not a
luminance claim. This is why the OS setting, not the terminal's background
colour, drives the choice.

### Scope decisions (confirmed with owner)

| Decision | Choice |
|---|---|
| Themes named in the request | **Kept verbatim** — no substitutions for luminance |
| Day/night signal | **OS appearance** — XDG desktop portal on Linux, `defaults` on macOS |
| Change detection | **Push** — subscribe to the portal's `SettingChanged` signal |
| Pair switching | `<leader>tt` cycles; active pair **persisted** across restarts |
| Sourcing `fairyfloss` | **Local `mini.base16` port**, its own file in `colors/` |
| Sourcing the Django themes | **Local `mini.base16` ports** in `colors/` |
| Contrast floor for new ports | **Split** — 4.5:1 for high-traffic roles, 3:1 for accents |
| Ghostty config | **Untouched** — Neovim-only; nothing written outside this repo |
| `lualine` theme | Stays `"auto"`; no per-pair statusline palette |
| Unused themes | **Removed** from plugin pack, Lua config, and docs |

## Day/Night Resolution

### Reading the setting

Asynchronous, via `vim.system()` (Neovim 0.12.4 on the host).

**Linux** — the XDG desktop portal, which is desktop-agnostic. `gsettings` is
*not* usable here: COSMIC reports `No schemas installed`.

```
gdbus call --session --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop \
  --method org.freedesktop.portal.Settings.ReadOne \
  org.freedesktop.appearance color-scheme
→ (<uint32 2>,)
```

| Value | Meaning | Slot |
|---|---|---|
| `0` | no preference | day |
| `1` | prefer dark | night |
| `2` | prefer light | day |

**macOS:**

```
defaults read -g AppleInterfaceStyle
→ "Dark"        (exit 0)   → night
→ (error)       (exit 1)   → day
```

If neither command is available, keep the current colorscheme and do not switch.

### Noticing changes

A single long-lived `gdbus monitor` job, started at `VimEnter` and stopped at
`VimLeave`:

```
gdbus monitor --session --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop
```

Any output line containing `color-scheme` is treated purely as a **trigger**:
the handler re-runs the `ReadOne` query above and uses *that* result. Values are
never parsed out of the monitor's text, so its output format is not a
correctness dependency.

macOS has no equivalent push signal; there, re-query on `FocusGained` instead.
If `gdbus` is missing on Linux, fall back to `FocusGained` as well.

### Applying a slot

`'background'` must be assigned by this config, because `melange` and
`tokyonight` both read it and the terminal will report `dark` for the Fairyfloss
and Django slots. This **reverses** the current file's "never assign it here"
rule, which was correct only while the terminal was the signal.

Order matters: set `'background'` *first*, then `:colorscheme`. Assigning
`'background'` makes Neovim reload the active colorscheme, so doing it second
would re-source the wrong theme.

The `OptionSet background` autocmd is removed. With no autocmd keyed on
`'background'`, a colorscheme that assigns `'background'` itself can no longer
re-enter the apply path, so no re-entrancy guard is needed.

### Startup ordering

The portal query is async, so a first paint would otherwise flash the default
colorscheme. At startup, apply the persisted pair **provisionally** using the
`'background'` the terminal already reported, then correct once the query
returns. In the common case the two agree and nothing repaints.

## Tech Stack

- Neovim 0.12.4 (host-installed; not pinned by this repo)
- Plugin pack built with Nix — `flake.nix` + `modules/plugins.nix`, materialized
  into `~/.local/share/nvim/site/pack/nix`
- Lua config under `lua/`, symlinked into `~/.config/nvim` by `task install`
- `mini.base16` for palette-generated colorschemes in `colors/`
- `gdbus` (glib) on Linux; `defaults` on macOS. Both are host tools, not deps.
- Task runner: `go-task` (`Taskfile.yml`)

### Plugin pack changes

**Remove** (no longer referenced by any pair):

```
catppuccin-nvim   cyberdream-nvim   kanagawa-nvim
vim-moonfly-colors   onenord-nvim   miasma-nvim   aurora
```

**Keep:** `melange-nvim`, `tokyonight-nvim`, `mini-base16`.

**Add:** nothing. Porting Fairyfloss locally means `flake.nix` is unchanged and
no new flake input is introduced.

## Commands

```
Build pack:    task build                # nix build .#nvim-plugin-pack (or Docker)
Install:       task install              # copy pack + symlink lua/, colors/, init.lua
Rebuild all:   task rebuild              # build + install
Format:        task fmt                  # stylua . && nixfmt flake.nix modules/*.nix
Lint:          task lint                 # stylua --check . && nixfmt --check
Test:          task test                 # luacheck lua/ colors/ && actionlint
```

Smoke-test one colorscheme without a full install:

```
nvim --headless -c 'colorscheme django' -c 'quitall'
```

Check the OS appearance signal by hand:

```
gdbus call --session --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop \
  --method org.freedesktop.portal.Settings.ReadOne \
  org.freedesktop.appearance color-scheme
```

## Project Structure

```
lua/config/colorscheme.lua        → pair table, OS query, monitor, persistence, <leader>tt
colors/belafonte-day.lua          → existing mini.base16 port (unchanged)
colors/fairyfloss.lua             → new mini.base16 port of Ghostty "Fairyfloss"
colors/django.lua                 → new mini.base16 port of Ghostty "Django"
colors/django-reborn-again.lua    → new mini.base16 port of "Django Reborn Again"
modules/plugins.nix               → plugin pack list (removals only)
docs/plugins/*.md                 → one page per surviving theme; removed pages deleted
docs/README.md                    → index, updated to match
docs/specs/theme-pairs.md         → this spec
```

`flake.nix` is not modified. `colors/` is already symlinked as a directory by
`task install`, so new files there need no reinstall — but removing plugins does
require `task rebuild`.

State file (outside the repo):

```
$(stdpath("state"))/theme-pair.txt   → e.g. ~/.local/state/nvim/theme-pair.txt
```

Contents: the active pair id on a single line (`earthy`, `cyber`, or `emerald`).
A missing, empty, or unrecognized file falls back to `earthy` without erroring.

## Code Style

Matches the existing `colorscheme.lua`: a flat table of data, small local
functions, and comments explaining *why* a value was chosen rather than what the
line does. `stylua.toml` governs formatting (2-space indent, 100 columns, double
quotes, always-parenthesized calls).

```lua
-- Each pair mirrors a Ghostty `theme = light:...,dark:...` line. `bg` is the
-- theme's actual luminance, which is NOT the same as its slot: Fairyfloss and
-- both Django themes are dark-background themes sitting in day slots. melange
-- and tokyonight read 'background', so this config has to assign it.
local pairs_by_id = {
  {
    id = "earthy",
    day = { scheme = "belafonte-day", bg = "light" },
    night = { scheme = "melange", bg = "dark" },
  },
  {
    id = "cyber",
    day = { scheme = "fairyfloss", bg = "dark" },
    night = { scheme = "tokyonight-moon", bg = "dark" },
  },
  {
    id = "emerald",
    day = { scheme = "django", bg = "dark" },
    night = { scheme = "django-reborn-again", bg = "dark" },
  },
}

-- Assigning 'background' reloads the active colorscheme, so it has to come
-- first -- setting it afterwards would re-source the theme we just replaced.
local function apply(slot)
  local entry = pairs_by_id[current][slot]
  vim.o.background = entry.bg
  vim.cmd.colorscheme(entry.scheme)
end
```

The three new ports follow `colors/belafonte-day.lua` exactly: a `mini.base16`
palette table, one trailing comment per entry naming the role, a header comment
recording which values are verbatim from Ghostty and which were lifted for
contrast, and `vim.g.colors_name` set at the bottom.

## Palette Porting Rules

For each of `fairyfloss`, `django`, and `django-reborn-again`:

1. `base00` (background) and `base05` (foreground) are taken **verbatim** from
   the Ghostty theme's `background` and `foreground`.
2. `base02` is the Ghostty `selection-background`, verbatim.
3. Accent slots keep the Ghostty ANSI hue but are lifted in lightness until they
   clear their floor against `base00`. The floor is **split by how much text a
   slot paints**, because Fairyfloss's mid-tone background caps contrast at
   7.10:1 and a flat 4.5:1 would wash its palette to pastel and collapse
   `base08` onto `base0E`:

   | Floor | Slots | Roles |
   |---|---|---|
   | **4.5:1** | `base03`, `base0B`, `base0D`, `base0F` | comments, line numbers, sign column, strings, functions, delimiters |
   | **3:1** | `base08`, `base09`, `base0A`, `base0C`, `base0E` | variables, constants, types, escapes, keywords |

   Both Django themes clear 4.5:1 on every slot regardless, so the split only
   changes Fairyfloss. Every lifted value is noted in the file header with its
   original and its measured ratio.
4. Neutral ramp steps the theme does not define (`base01`, `base03`, `base04`,
   `base06`) are interpolated between the ones it does.
5. Where a theme has fewer than eight distinct accent hues, hues are reused and
   the reuse is documented — the `belafonte-day` precedent.

Known problem slots:

| Theme | Slot | Ghostty value | Ratio vs. bg | Action |
|---|---|---|---|---|
| `django` | `base0D` blue | `#315d3f` | ~1.5:1 | lift |
| `django` | `base0E` magenta | `#f8f8f8` | — | it is white; substitute a distinct hue |
| `django-reborn-again` | `base0D` blue | `#245032` | ~1.4:1 | lift |
| `fairyfloss` | `base0F` delimiters | `#6090cb` | 2.15:1 | lift |
| `fairyfloss` | `base08` variables | `#f92672` | 1.87:1 | lift |

Fairyfloss assigns the same `#c2ffdf` mint to ANSI green, blue, and bright-blue,
so its accents are drawn from the colours its own vim colorscheme uses for each
syntax role rather than from the ANSI slots alone.

`base03` also drives `LineNr`, `SignColumn`, `StatusLineNC`, and `TabLine`, so it
must stay a neutral in every port. Fairyfloss's signature gold comment is
restored by an explicit `Comment` override after `setup()` rather than by
colouring `base03`.

## Testing Strategy

There is no Lua test harness in this repo, and none is added here.

| Level | What it covers | Command |
|---|---|---|
| Static | Formatting, unused locals, undefined globals | `task lint`, `task test` |
| Smoke | Each of the six colorschemes loads headlessly without error | `nvim --headless -c 'colorscheme X' -c 'quitall'` |
| Contrast | Every accent clears its floor vs. `base00` | computed while authoring; ratios recorded in each file header |
| Manual | Slot selection, live switching, cycling, persistence, readability | checklist below, on the host after `task rebuild` |

**Manual checklist:**

1. Launch Neovim. Confirm the theme matches the persisted pair and the current
   OS appearance.
2. With Neovim open **and focused**, flip the OS appearance in COSMIC settings.
   Neovim repaints to the other slot within ~1s, without input.
3. `<leader>tt` → notifies `Theme: cyber (day)`; the buffer repaints.
4. `<leader>tt` twice more → `emerald`, then back to `earthy`.
5. Quit, relaunch → the pair from step 4's stopping point is restored.
6. `rm ~/.local/state/nvim/theme-pair.txt`, relaunch → starts at `earthy`, no error.
7. Quit Neovim, then `pgrep -af 'gdbus monitor'` → no orphaned process remains.
8. In each of the six themes, open a Lua and a Markdown buffer and confirm
   comments, strings, functions, and diagnostics are all legible.

Steps 2, 7, and 8 are the acceptance gates for the OS signal, process lifecycle,
and the ports' contrast work respectively.

## Boundaries

**Always:**
- Update the matching `docs/plugins/*.md` page and `docs/README.md` in the same
  change as any keybinding, plugin, or option change.
- Run `task fmt` then `task lint && task test` before considering work done.
- Record in each `colors/*.lua` header which palette values are verbatim from
  Ghostty and which were lifted, with the measured contrast ratio.
- Stop the `gdbus monitor` job on `VimLeave`.
- Track work in `bd`, not TodoWrite or markdown checklists.

**Ask first:**
- Substituting a different colorscheme for any of the six named above.
- Adding a plugin or flake input.
- Changing `<leader>tt`'s meaning beyond "cycle pair".
- Lowering either contrast floor for any accent.

**Never:**
- Commit, push, or open a PR — the owner does this.
- Write to any file outside this repo except `stdpath("state")/theme-pair.txt`.
  In particular, never modify `~/.config/ghostty/config`.
- Block the UI on the appearance query — it is always async.
- Delete pre-existing unrelated code or docs that this change did not orphan.
- Leave a `docs/` page describing a theme that is no longer in the pack.

## Success Criteria

1. `lua/config/colorscheme.lua` contains exactly the three pairs above and no
   reference to catppuccin, cyberdream, kanagawa, moonfly, onenord, miasma, or
   aurora.
2. `modules/plugins.nix` lists `melange-nvim`, `tokyonight-nvim`, and
   `mini-base16` among the themes, and none of the seven removed ones.
   `flake.nix` is unchanged.
3. `nix build .#nvim-plugin-pack` succeeds; the result contains no directory for
   any removed theme.
4. All six colorschemes load headlessly with no error and no `E185`.
5. `task lint` and `task test` both pass.
6. Every accent in the three new `colors/*.lua` files clears its floor against
   its `base00` (4.5:1 for `base03`/`base0B`/`base0D`/`base0F`, 3:1 for the
   rest), with each lifted value's ratio recorded in the file header.
7. Flipping the OS appearance while Neovim is focused repaints it to the other
   slot of the active pair within ~1s, with no keypress.
8. `<leader>tt` cycles `earthy → cyber → emerald → earthy`, notifying the pair id
   and resolved slot each time, and preserving the current slot across the change.
9. The active pair is written to `stdpath("state")/theme-pair.txt` on change and
   read at startup; an absent or garbage file falls back to `earthy` silently.
10. No `gdbus monitor` process survives Neovim exiting.
11. `grep -ril` for each removed theme returns no hits outside `docs/specs/` and
    git history.
12. `docs/README.md` indexes exactly the surviving theme pages, and pages exist
    for `fairyfloss`, `django`, and `django-reborn-again`.

## Open Questions

None outstanding. Previously raised and now resolved:

| Question | Resolution |
|---|---|
| Day/night inert for `cyber`/`emerald` under the terminal signal | Switched to the OS appearance signal |
| `tssm/fairyfloss.vim` lacks treesitter and LSP groups | Hand-ported via `mini.base16` instead |
| Should switching rewrite `~/.config/ghostty/config`? | No — Neovim only |
| `lualine` has no theme for the new colorschemes | Accepted; stays `theme = "auto"` |
| Contrast floor for the new ports | Split: 4.5:1 high-traffic, 3:1 accents |
