{
  pkgs,
  symlink,
  dotfiles,
  ...
}:
{
  home.packages = [ pkgs.ghostty ];
  xdg.configFile."ghostty/config.ghostty".source =
    symlink "${dotfiles}/programs/ghostty/config.ghostty";
}
