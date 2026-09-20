{
  pkgs,
  symlink,
  dotfiles,
  ...
}:
{
  home.packages = [ pkgs.git ];
  xdg.configFile."git/config".source = symlink "${dotfiles}/programs/git/gitconfig";
}
