{
  description = "Joshua's Neovim configuration — a self-contained nvim built via Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    octo-nvim-src = {
      url = "github:pwntester/octo.nvim";
      flake = false;
    };
    agentic-nvim-src = {
      url = "github:carlos-algms/agentic.nvim";
      flake = false;
    };
    notion-nvim-src = {
      url = "github:ALT-F4-LLC/notion.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      octo-nvim-src,
      agentic-nvim-src,
      notion-nvim-src,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          # terraform is unfree, so the tools bundle needs an unfree-allowing pkgs.
          pkgsUnfree = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          # Language servers + formatters bundled onto the editor's PATH.
          lspTools = import ./modules/lsp-tools.nix { pkgs = pkgsUnfree; };
          # All plugin derivations (includes the prebuilt tree-sitter parser pack).
          plugins = import ./modules/plugins.nix {
            inherit
              pkgs
              octo-nvim-src
              agentic-nvim-src
              notion-nvim-src
              ;
          };
          # The lua/ + colors/ config, packaged as a plugin. `./.` is a real path
          # (lib.fileset needs a path, not the string-like `self`).
          configPlugin = import ./modules/config.nix {
            inherit pkgs;
            src = ./.;
          };
        in
        {
          # The self-contained editor: plugins + config + parsers + tooling, all
          # in one `nvim`. `nix run` / `nix profile install .#`.
          default = import ./modules/neovim.nix {
            inherit
              pkgs
              plugins
              configPlugin
              lspTools
              ;
          };
          # The language-server/formatter bundle on its own (also on the editor's
          # PATH above); handy for `nix profile install .#lsp-tools` or reuse.
          lsp-tools = lspTools;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
          meta.description = "Joshua's self-contained Neovim";
        };
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pkgsUnfree = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          lspTools = import ./modules/lsp-tools.nix { pkgs = pkgsUnfree; };
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.stylua
              pkgs.nixfmt
              pkgs.luajitPackages.luacheck
              pkgs.actionlint
              pkgs.neovim
            ];
          };
          # Drop into a shell with every language server and formatter on PATH.
          lsp = pkgs.mkShell {
            packages = [ lspTools ];
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
