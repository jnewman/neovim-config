{
  description = "Joshua's Neovim configuration — plugin pack built via Nix, nvim runs on host";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    octo-nvim-src = {
      url = "github:pwntester/octo.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      octo-nvim-src,
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
        in
        {
          nvim-plugin-pack = import ./modules/plugins.nix { inherit pkgs octo-nvim-src; };
          default = import ./modules/plugins.nix { inherit pkgs octo-nvim-src; };
          # Language servers + formatters the editor runs natively on a nix host.
          lsp-tools = import ./modules/lsp-tools.nix { pkgs = pkgsUnfree; };
        }
      );

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
