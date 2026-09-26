{ pkgs, ... }:
{
    home.packages = with pkgs; [
        antigravity-cli
        codex
        github-copilot-cli
    ];
}
