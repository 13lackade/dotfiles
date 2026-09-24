{ config, pkgs, ... }:
{
  _module.args = {
    symlink = config.lib.file.mkOutOfStoreSymlink;
    dotfiles = "${config.home.homeDirectory}/Workspace/github.com/13lackade/dotfiles";
    plugins = import ./_sources/generated.nix {
      inherit (pkgs)
        fetchurl
        fetchgit
        fetchFromGitHub
        dockerTools
        ;
    };
  };

  home.username = "blackade";
  home.packages = with pkgs; [
    mpv
    antigravity-cli
    slack
    discord
  ];
  systemd.user.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
  home.stateVersion = "26.05";

  imports = [
    ./programs/git
    ./programs/ghostty
    ./programs/shojiwm
    ./programs/zsh
    ./programs/tmux
    ./programs/neovim
    ./programs/skk.nix
    ./programs/zen.nix
    ./programs/fontconfig.nix
  ];
}
