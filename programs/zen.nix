{ inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.beta ];
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    policies = {
      ExtensionSettings."uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };

      "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite.filterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-unbreak"
        "ublock-quick-fixes"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "plowe-0"
        "JPN-1"

        "https://raw.githubusercontent.com/gijsdev/ublock-hide-yt-shorts/master/list.txt"
      ];

      "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite.filters = [
        "pawnyable.cafe##body, p, li, .post-title, .profile-body:style(font-family: 'Inter', 'Noto Sans CJK JP', sans-serif !important;)"
      ];
    };
  };

  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = "zen-beta.desktop";
    };
  };
}
