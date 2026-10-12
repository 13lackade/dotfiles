{
  config,
  lib,
  pkgs,
  ...
}:
{
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "ignore";
  };

  services.printing = {
    enable = true;
    clientConf = ''
      SSLOptions NoSystem MaxTLS1.2
    '';
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  users.users.blackade = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "libvirtd"
      "incus-admin"
    ];
  };

  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };
  environment.etc."ssl/cert.pem".source = "/etc/ssl/certs/ca-bundle.crt";

  environment.variables.EDITOR = null;

  programs.dconf.enable = true;
}
