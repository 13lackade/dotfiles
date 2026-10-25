{
  _module.args.host = "vm";

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-vm";
}
