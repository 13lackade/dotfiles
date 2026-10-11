{ ... }:
{
  networking = {
    hostName = "beryllium";
    nftables.enable = true;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
