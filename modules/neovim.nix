# The final, self-contained Neovim: the plugin set + the Lua config + prebuilt
# tree-sitter parsers wrapped into one `nvim`, with every tool the config shells
# out to on its PATH. `nix run`/`nix profile install` gives a ready editor with
# nothing symlinked into ~/.config/nvim and no Docker.
{
  pkgs,
  # Plugin derivations from modules/plugins.nix (includes the parser pack).
  plugins,
  # The lua/ + colors/ config packaged as a plugin (modules/config.nix).
  configPlugin,
  # Language servers + formatters bundle (modules/lsp-tools.nix).
  lspTools,
  # Theme pair id (e.g. "cyber") to start in, overriding the pair persisted by
  # `<leader>tt`. null keeps the persisted pair. Set from a consuming config with
  # `neovim-config.packages.${system}.default.override { themePair = "cyber"; }`.
  themePair ? null,
  # Leave the editor's base backgrounds unpainted so the terminal's background and
  # opacity show through. false keeps the theme's own opaque background.
  transparent ? true,
}:
let
  # Everything the config invokes at runtime, resolved off the wrapper's PATH:
  #   lspTools      language servers + formatters (also mmdc/magick/tree-sitter/gcc)
  #   gh            octo.nvim (aborts init if missing)
  #   curl          kulala.nvim HTTP client
  #   imagemagick   image.nvim magick_cli processor (mermaid preview)
  #   mermaid-cli   mmdc, renders mermaid to PNG
  #   glib          gdbus, colorscheme OS light/dark detection on Linux
  runtimeDeps = [
    lspTools
    pkgs.gh
    pkgs.curl
    pkgs.imagemagick
    pkgs.mermaid-cli
    pkgs.glib
  ];

in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  withPython3 = false;
  withRuby = false;
  withNodeJs = false;
  plugins = map (p: { plugin = p; }) (plugins ++ [ configPlugin ]);
  # Nix-side settings are handed to the Lua config as vim.g globals, set before
  # the config's require-chain (configPlugin ships lua/init.lua on rtp) runs.
  luaRcContent =
    pkgs.lib.optionalString (themePair != null) "vim.g.theme_pair = ${builtins.toJSON themePair}\n"
    + "vim.g.theme_transparent = ${pkgs.lib.boolToString transparent}\n"
    + "require('init')";
  wrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (pkgs.lib.makeBinPath runtimeDeps)
  ];
}
