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
        in
        {
          nvim-plugin-pack = import ./modules/plugins.nix { inherit pkgs octo-nvim-src; };
          default = import ./modules/plugins.nix { inherit pkgs octo-nvim-src; };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
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
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
