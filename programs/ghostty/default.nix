{
  pkgs,
  symlink,
  dotfiles,
  standalone,
  lib,
  ...
}:
{
  home.packages = [ pkgs.ghostty ];
  xdg.configFile."ghostty/config.ghostty".source =
    symlink "${dotfiles}/programs/ghostty/config.ghostty";
  xdg.dataFile."applications/com.mitchellh.ghostty.desktop".source =
    lib.mkIf standalone
      "${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop";
  xdg.configFile."systemd/user/app-com.mitchellh.ghostty.service".source =
    lib.mkIf standalone
      "${pkgs.ghostty}/share/systemd/user/app-com.mitchellh.ghostty.service";
}
