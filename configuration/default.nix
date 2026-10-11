{ ... }:
{
  imports = [
    ./configuration.nix
    ./shojiwm.nix
    ./nix.nix
    ./boot.nix
  ];

  system.stateVersion = "26.05";
}
