{
  pkgs,
  symlink,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    pavucontrol
    thunar
    firefox
    slack
    discord

    xdg-utils
    brightnessctl
    playerctl
    mpv
  ];

  xdg.configFile."hypr" = {
    source = symlink "${dotfiles}/programs/desktop/hypr";
    recursive = true;
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  systemd.user.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
