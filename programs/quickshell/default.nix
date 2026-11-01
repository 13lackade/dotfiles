{
  pkgs,
  symlink,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    quickshell
    networkmanagerapplet
    blueman
    swaylock
  ];
  xdg.configFile."quickshell".source = symlink "${dotfiles}/programs/quickshell/config";
}
