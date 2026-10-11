{ ... }:
{
  virtualisation.docker = {
    enable = true;

    enableOnBoot = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [
        "--all"
        "--volumes"
      ];
    };
  };
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.incus.enable = true;

  programs.virt-manager.enable = true;
}
