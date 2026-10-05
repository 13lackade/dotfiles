{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    # simple-scan
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "beryllium";

  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true;
  # };

  hardware.bluetooth.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "ignore";
  };

  services.printing = {
    enable = true;
    clientConf = ''
      SSLOptions NoSystem MaxTLS1.2
    '';
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  # hardware.sane.enable = true;

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      shojiwm = {
        prettyName = "ShojiWM";
        comment = "ShojiWM managed by UWSM";
        binPath = "/run/current-system/sw/bin/shoji_wm";
        extraArgs = [
          "--tty"
          "--log-off"
        ];
      };
    };
  };

  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.uwsm}/bin/uwsm start shojiwm-uwsm.desktop";
        user = "blackade";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd '${pkgs.uwsm}/bin/uwsm start shojiwm-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  virtualisation.docker = {
    enable = true;

    enableOnBoot = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [
        "--all"
        "--volumes"
      ];
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  users.users.blackade = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };
  environment.etc."ssl/cert.pem".source = "/etc/ssl/certs/ca-bundle.crt";

  environment.variables.EDITOR = null;

  system.stateVersion = "26.05";
}
