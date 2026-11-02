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
  xdg.configFile."ghostty/nix.ghostty".text = ''
    window-decoration = ${if standalone then "auto" else "none"}
    ${if standalone then "" else "font-family = monospace"}
    font-feature = -calt, -liga, -dlig, +zero
  '';

  xdg.dataFile."applications/com.mitchellh.ghostty.desktop" = lib.mkIf standalone {
    source = "${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop";
  };
  xdg.configFile."systemd/user/app-com.mitchellh.ghostty.service" = lib.mkIf standalone {
    source = "${pkgs.ghostty}/share/systemd/user/app-com.mitchellh.ghostty.service";
  };
}
