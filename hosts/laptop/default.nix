{
  _module.args = {
    host = "laptop";
  };

  imports = [
    ./hardware-configuration.nix
    ../../hardware/fmvu90h1.nix
  ];

  networking.hostName = "beryllium";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  hardware.bluetooth.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "ignore";
  };

}
