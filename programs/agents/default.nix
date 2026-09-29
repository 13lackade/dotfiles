{
  pkgs,
  symlink,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    antigravity-cli
    codex
    github-copilot-cli

    fd
    jq
    yq-go
    ast-grep
    just
    rtk

    nixd
    statix
    deadnix
    shellcheck
    shfmt

    gh
    nh
    nix-output-monitor
    nix-index
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".codex/AGENTS.md".source = symlink "${dotfiles}/programs/agents/AGENTS.md";
}
