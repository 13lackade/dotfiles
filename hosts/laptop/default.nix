{
  _module.args = {
    host = "laptop";
  };

  imports = [
    ./hardware-configuration.nix
    ../../hardware/fmvu90h1.nix
  ];

  networking.hostName = "beryllium";
}
