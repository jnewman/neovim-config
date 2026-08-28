require("tokyonight").setup({
  style = "moon",
  transparent = false,
  terminal_colors = true,
})

-- melange is configured via vim globals rather than a setup() function, and needs
-- none of them at their non-default values. Every other scheme below lives in
-- colors/ and generates its groups with mini.base16.

-- Theme pairs, each mirroring a Ghostty `theme = light:...,dark:...` line. `bg` is
-- the colorscheme's actual luminance, which is NOT the same as its slot: every day
-- scheme except belafonte-day is a dark-background theme, so "day" names the pair
-- member rather than a claim about lightness. melange and tokyonight both read
-- 'background', so this config assigns it instead of letting the terminal decide.
local theme_pairs = {
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
    day = { scheme = "django-smooth", bg = "dark" },
    night = { scheme = "django-reborn-again", bg = "dark" },
  },
  {
    id = "black",
    day = { scheme = "chalk", bg = "dark" },
    night = { scheme = "gruvbox-dark-hard", bg = "dark" },
  },
  {
    id = "blue",
    day = { scheme = "blue-dolphin", bg = "dark" },
    night = { scheme = "hivacruz", bg = "dark" },
  },
}

local is_mac = vim.fn.has("mac") == 1
local state_file = vim.fs.joinpath(vim.fn.stdpath("state"), "theme-pair.txt")

local function index_of(id)
  for i, pair in ipairs(theme_pairs) do
    if pair.id == id then
      return i
    end
  end
end

-- readfile() throws when the file does not exist, which is the ordinary first-run
-- case. A missing, empty, or unrecognized value falls back to the first pair.
local function load_pair()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if not ok or not lines[1] then
    return 1
  end
  return index_of(vim.trim(lines[1])) or 1
end

local current = load_pair()

-- Seeded from whatever the terminal already reported so the first paint is right
-- in the common case; the OS query below corrects it if the two disagree.
local slot = vim.o.background == "dark" and "night" or "day"

-- Assigning 'background' reloads the active colorscheme, so it has to come first:
-- setting it afterwards would re-source the theme we just replaced.
local function apply()
  local entry = theme_pairs[current][slot]
  vim.o.background = entry.bg
  vim.cmd.colorscheme(entry.scheme)
end

-- The OS light/dark setting, not the terminal background, decides the slot: nine of
-- the ten themes are dark-background, so the terminal cannot tell the slots apart.
-- Linux reads the XDG desktop portal because it is desktop-agnostic — COSMIC ships
-- no gsettings schemas. macOS reads the global domain.
local appearance_cmd = is_mac and { "defaults", "read", "-g", "AppleInterfaceStyle" }
  or {
    "gdbus",
    "call",
    "--session",
    "--dest",
    "org.freedesktop.portal.Desktop",
    "--object-path",
    "/org/freedesktop/portal/desktop",
    "--method",
    "org.freedesktop.portal.Settings.ReadOne",
    "org.freedesktop.appearance",
    "color-scheme",
  }

-- Portal `color-scheme`: 0 = no preference, 1 = prefer dark, 2 = prefer light.
-- `defaults read` exits non-zero when the key is absent, which itself means light.
local function parse_appearance(out)
  local stdout = out.stdout or ""
  if is_mac then
    return (out.code == 0 and stdout:find("Dark")) and "night" or "day"
  end
  return stdout:match("uint32%s+1") and "night" or "day"
end

local function refresh()
  if vim.fn.executable(appearance_cmd[1]) == 0 then
    return
  end
  vim.system(appearance_cmd, { text = true }, function(out)
    local next_slot = parse_appearance(out)
    vim.schedule(function()
      if next_slot ~= slot then
        slot = next_slot
        apply()
      end
    end)
  end)
end

-- One long-lived subscription rather than polling. The signal is only a trigger —
-- its payload is never parsed, so the monitor's output format is not a correctness
-- dependency; the authoritative value always comes from a fresh query. Hosts
-- without the portal fall back to re-checking when the terminal regains focus.
local monitor

local function watch_appearance()
  if is_mac or vim.fn.executable("gdbus") == 0 then
    vim.api.nvim_create_autocmd("FocusGained", { callback = refresh })
    return
  end
  monitor = vim.system({
    "gdbus",
    "monitor",
    "--session",
    "--dest",
    "org.freedesktop.portal.Desktop",
    "--object-path",
    "/org/freedesktop/portal/desktop",
  }, {
    text = true,
    stdout = function(_, data)
      if data and data:find("color%-scheme") then
        vim.schedule(refresh)
      end
    end,
  })
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if monitor then
      monitor:kill("sigterm")
    end
  end,
})

apply()
refresh()
watch_appearance()

vim.keymap.set("n", "<leader>tt", function()
  current = (current % #theme_pairs) + 1
  apply()
  vim.fn.writefile({ theme_pairs[current].id }, state_file)
  vim.notify(("Theme: %s (%s)"):format(theme_pairs[current].id, slot), vim.log.levels.INFO)
end, { desc = "Cycle theme pair" })
