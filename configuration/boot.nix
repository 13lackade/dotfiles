{ ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };

      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    tmp.cleanOnBoot = true;
  };
}
