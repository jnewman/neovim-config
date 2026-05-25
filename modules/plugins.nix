{ pkgs, octo-nvim-src }:
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
      pkg = pkgs.vimPlugins.octo-nvim.overrideAttrs (_: {
        src = octo-nvim-src;
        version = "HEAD";
      });
    }
    {
      name = "diffview-nvim";
      pkg = pkgs.vimPlugins.diffview-nvim;
    }
    {
      name = "gitsigns-nvim";
      pkg = pkgs.vimPlugins.gitsigns-nvim;
    }
    {
      name = "blink-cmp";
      pkg = pkgs.vimPlugins.blink-cmp;
    }
    {
      name = "oil-nvim";
      pkg = pkgs.vimPlugins.oil-nvim;
    }
    {
      name = "which-key-nvim";
      pkg = pkgs.vimPlugins.which-key-nvim;
    }
    {
      name = "nvim-autopairs";
      pkg = pkgs.vimPlugins.nvim-autopairs;
    }
    {
      name = "comment-nvim";
      pkg = pkgs.vimPlugins.comment-nvim;
    }
    {
      name = "lualine-nvim";
      pkg = pkgs.vimPlugins.lualine-nvim;
    }
    {
      name = "indent-blankline-nvim";
      pkg = pkgs.vimPlugins.indent-blankline-nvim;
    }
    {
      name = "flash-nvim";
      pkg = pkgs.vimPlugins.flash-nvim;
    }
  ];
in
pkgs.runCommand "nvim-plugin-pack" { } ''
  mkdir -p $out/pack/nix/start
  ${pkgs.lib.concatMapStrings (p: ''
    cp -rL ${p.pkg} $out/pack/nix/start/${p.name}
  '') plugins}
''
