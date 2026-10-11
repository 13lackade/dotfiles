{ ... }:
{
  imports = [
    ./configuration.nix
    ./shojiwm.nix
    ./nix.nix
  ];

  system.stateVersion = "26.05";
}
