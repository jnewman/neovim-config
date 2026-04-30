{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = builtins.readFile ../lua/init.lua;
  };

  # Expose the Lua config files where Neovim can find them
  xdg.configFile."nvim/lua".source = ../lua;
}
