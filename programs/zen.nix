{ inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.beta ];
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = "zen-beta.desktop";
    };
  };
}
