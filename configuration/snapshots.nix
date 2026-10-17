{
  services.btrbk.instances.home = {
    onCalendar = "hourly";
    settings = {
      timestamp_format = "long";
      snapshot_preserve_min = "24h";
      snapshot_preserve = "24h 7d 4w";
      volume."/" = {
        snapshot_dir = ".snapshots/home";
        subvolume."home" = { };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /.snapshots 0750 root btrbk -"
    "d /.snapshots/home 0750 root btrbk -"
  ];

  systemd.services.btrbk-home = {
    unitConfig.RequiresMountsFor = [
      "/home"
      "/.snapshots/home"
    ];
  };
}
