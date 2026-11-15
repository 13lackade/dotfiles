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
    (pkgs.writeShellApplication {
      name = "notify";
      runtimeInputs = [ pkgs.libnotify ];
      text = builtins.readFile ./notify.sh;
    })
  ];
  home.file.".zshrc".source = symlink "${dotfiles}/programs/zsh/zshrc";
  xdg.dataFile."zsh/site/zsh-syntax-highlighting" = {
    source = plugins."zsh-syntax-highlighting".src;
    recursive = true;
  };
}
