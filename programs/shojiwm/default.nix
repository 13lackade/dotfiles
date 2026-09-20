{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.agsFull
    brightnessctl
    cliphist
    wl-clipboard
    imagemagick
    bluez

    xdg-utils
    pavucontrol

    bibata-cursors
  ];
}
