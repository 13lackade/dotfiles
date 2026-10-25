{ ... }:
{
  networking = {
    nftables.enable = true;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
