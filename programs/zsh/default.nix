{
  pkgs,
  symlink,
  dotfiles,
  plugins,
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
  xdg.dataFile."zsh/site/zsh-syntax-highlighting" = {
    source = plugins."zsh-syntax-highlighting".src;
    recursive = true;
  };
}
