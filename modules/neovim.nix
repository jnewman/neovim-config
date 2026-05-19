{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = false;

    plugins = [
      pkgs.vimPlugins.catppuccin-nvim
      pkgs.vimPlugins.cyberdream-nvim
      pkgs.vimPlugins.tokyonight-nvim
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.lua
        p.vim
        p.vimdoc
        p.nix
      ]))
      pkgs.vimPlugins.conform-nvim
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.octo-nvim
      pkgs.vimPlugins.diffview-nvim
      pkgs.vimPlugins.gitsigns-nvim
    ];

    extraPackages = [
      pkgs.lua-language-server
      pkgs.stylua
      pkgs.nixd
      pkgs.nixfmt
      pkgs.gh
    ];

    initLua = builtins.readFile ../lua/init.lua;
  };

  # Expose the Lua config files where Neovim can find them
  xdg.configFile."nvim/lua".source = ../lua;
}
