{ pkgs, ... }:
{
  home.username = "joshua";
  home.homeDirectory = "/Users/joshua";
  home.stateVersion = "24.11";

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
