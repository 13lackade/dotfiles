{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.agsFull
    brightnessctl
    cliphist
    wl-clipboard
    imagemagick
    bluez
    hyprshot
    swappy
    mpv

    xdg-utils
    pavucontrol

    bibata-cursors
  ];
}
