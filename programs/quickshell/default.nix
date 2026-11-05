{
  pkgs,
  symlink,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    networkmanagerapplet
    blueman
    swaylock
    wl-clipboard
    imagemagick
  ];

  programs.quickshell = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
  systemd.user.services.quickshell.Unit.PartOf = [ "graphical-session.target" ];

  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = [ "graphical-session.target" ];
  };

  xdg.configFile."quickshell".source = symlink "${dotfiles}/programs/quickshell/config";
}
