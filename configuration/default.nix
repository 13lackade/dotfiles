{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
  ];

  imports = [
    ./configuration.nix
    ./shojiwm.nix
    ./nix.nix
    ./boot.nix
    ./networking.nix
    ./virtualisation.nix
    ./greeter.nix
    ./snapshots.nix
    ./dotfiles.nix
  ];

  system.stateVersion = "26.05";
}
