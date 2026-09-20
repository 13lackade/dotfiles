{
  pkgs,
  symlink,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    zsh
    ghq
    fzf
    yazi
    eza
  ];

  home.file.".zshrc".source = symlink "${dotfiles}/programs/zsh/zshrc";
}
