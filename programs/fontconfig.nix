{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains-mono

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

    nerd-fonts.symbols-only
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
        "Symbols Nerd Font"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
        "Symbols Nerd Font"
      ];
      monospace = [
        "JetBrains Mono"
        "Noto Sans Mono CJK JP"
        "Symbols Nerd Font Mono"
      ];
      emoji = [
        "Noto Color Emoji"
        "Symbols Nerd Font"
      ];
    };
  };
}
