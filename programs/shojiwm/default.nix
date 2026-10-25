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
    (writeShellScriptBin "shojiwm-output-scale" ''
      # Deno requires --allow-all for access to Linux sysfs.
      exec ${deno}/bin/deno run --no-config --no-lock --allow-all \
        ${./output-scale.ts} "$@"
    '')
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
    thunar

    bibata-cursors

    firefox
    slack
    discord
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

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  systemd.user.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
