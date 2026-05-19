{
  description = "Joshua's Neovim configuration — Nix + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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
      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            ./modules/nix.nix
            ./modules/neovim.nix
          ];
        };
      };

      apps = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hmCli = home-manager.packages.${system}.home-manager;
          rebuildScript = pkgs.writeShellScript "rebuild" ''
            exec ${hmCli}/bin/home-manager switch --flake .#default
          '';
        in
        {
          rebuild = { type = "app"; program = toString rebuildScript; };
          default = { type = "app"; program = toString rebuildScript; };
        });

      devShells = forAllSystems (system:
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
        });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
