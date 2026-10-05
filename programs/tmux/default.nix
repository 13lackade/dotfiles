{
  pkgs,
  dotfiles,
  symlink,
  ...
}:
{
  home.packages = [ pkgs.tmux ];
  xdg.configFile."tmux/tmux.conf".source = symlink "${dotfiles}/programs/tmux/tmux.conf";
  xdg.configFile."tmux/nix.conf".text = ''
    set -g default-shell ${pkgs.zsh}/bin/zsh
  '';
}
