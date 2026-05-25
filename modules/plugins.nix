{ pkgs }:
let
  plugins = [
    {
      name = "catppuccin-nvim";
      pkg = pkgs.vimPlugins.catppuccin-nvim;
    }
    {
      name = "cyberdream-nvim";
      pkg = pkgs.vimPlugins.cyberdream-nvim;
    }
    {
      name = "tokyonight-nvim";
      pkg = pkgs.vimPlugins.tokyonight-nvim;
    }
    {
      name = "nvim-treesitter";
      pkg = pkgs.vimPlugins.nvim-treesitter;
    }
    {
      name = "conform-nvim";
      pkg = pkgs.vimPlugins.conform-nvim;
    }
    {
      name = "plenary-nvim";
      pkg = pkgs.vimPlugins.plenary-nvim;
    }
    {
      name = "telescope-nvim";
      pkg = pkgs.vimPlugins.telescope-nvim;
    }
    {
      name = "octo-nvim";
      pkg = pkgs.vimPlugins.octo-nvim;
    }
    {
      name = "diffview-nvim";
      pkg = pkgs.vimPlugins.diffview-nvim;
    }
    {
      name = "gitsigns-nvim";
      pkg = pkgs.vimPlugins.gitsigns-nvim;
    }
  ];
in
pkgs.runCommand "nvim-plugin-pack" { } ''
  mkdir -p $out/pack/nix/start
  ${pkgs.lib.concatMapStrings (p: ''
    cp -rL ${p.pkg} $out/pack/nix/start/${p.name}
  '') plugins}
''
