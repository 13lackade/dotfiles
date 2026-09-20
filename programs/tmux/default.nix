{
  pkgs,
  dotfiles,
  symlink,
  ...
}:
{
  home.packages = [ pkgs.tmux ];
  xdg.configFile."tmux/tmux.conf".source = symlink "${dotfiles}/programs/tmux/tmux.conf";
}
