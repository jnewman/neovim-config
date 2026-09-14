# The Lua configuration (lua/ + colors/) packaged as a Neovim plugin.
#
# Placed on the runtimepath by the wrapper, this makes `require("config.*")`
# resolve and the colorschemes in colors/ loadable, exactly as the old symlink
# install did with ~/.config/nvim. The wrapper drives startup with
# `require("init")`, which runs lua/init.lua's require-chain.
#
# Only lua/ and colors/ are included so docs/flake edits don't rebuild the editor.
{
  pkgs,
  # The flake source tree (self).
  src,
}:
let
  fs = pkgs.lib.fileset;
  configSrc = fs.toSource {
    root = src;
    fileset = fs.unions [
      (src + "/lua")
      (src + "/colors")
    ];
  };
in
pkgs.vimUtils.buildVimPlugin {
  pname = "jnewman-nvim-config";
  version = "1";
  src = configSrc;
  # Pure-Lua config: skip nvim's require-check (it would try to load config
  # modules that call setup() on plugins not present during this build).
  doCheck = false;
  nvimSkipModules = [ ];
}
