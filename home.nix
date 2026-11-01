{ config, pkgs, lib, standalone, ... }:
{
  _module.args = {
    symlink = config.lib.file.mkOutOfStoreSymlink;
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
    plugins = import ./_sources/generated.nix {
      inherit (pkgs)
        fetchurl
        fetchgit
        fetchFromGitHub
        dockerTools
        ;
    };
  };

  home.stateVersion = "26.05";

  xdg.mimeApps.enable = true;

  imports = [
    ./programs/git
    ./programs/ghostty
    ./programs/zsh
    ./programs/tmux
    ./programs/neovim
    ./programs/agents
  ] ++ lib.optionals (!standalone) [
    ./programs/shojiwm
    ./programs/quickshell
    ./programs/skk.nix
    ./programs/zen.nix
    ./programs/fontconfig.nix
  ];
}
