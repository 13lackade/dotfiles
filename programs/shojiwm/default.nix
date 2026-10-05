{
  pkgs,
  inputs,
  osConfig,
  symlink,
  dotfiles,
  ...
}:
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

  xdg.configFile = {
    "shojiwm/src".source = symlink "${dotfiles}/programs/shojiwm/src";
    "shojiwm/assets".source = symlink "${dotfiles}/programs/shojiwm/assets";
    "shojiwm/package.json".source = ./package.json;
    "shojiwm/tsconfig.json".source = ./tsconfig.json;
    "shojiwm/node_modules/shoji_wm".source =
      "${osConfig.programs.shojiwm.package}/lib/shojiwm/packages/shoji_wm";
  };

  services.batsignal = {
    enable = true;
    extraArgs = [
      "-w"
      "20"
      "-c"
      "10"
      "-d"
      "5"
      "-e"
    ];
  };

  dconf.settings."org/gnome/desktop/wm/preferences" = {
    button-layout = ":minimize,maximize,close";
  };
}
