{ pkgs, ... }:
{
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

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
