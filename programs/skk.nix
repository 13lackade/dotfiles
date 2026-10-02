{ pkgs, ... }:
let
  mkKeymap = parent: builtins.toJSON {
    include = [ "default/${parent}" ];
    define.keymap = {
      "\\" = null;
    };
  };
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-skk
        skkDictionaries.l
      ];
    };
  };

  xdg.configFile = {
    "libskk/rules/custom/metadata.json".text = builtins.toJSON {
      name = "Custom";
      description = "Default without kuten backslash";
    };

    "libskk/rules/custom/keymap/hiragana.json".text = mkKeymap "hiragana";
    "libskk/rules/custom/keymap/katakana.json".text = mkKeymap "katakana";
    "libskk/rules/custom/keymap/hankaku-katakana.json".text = mkKeymap "hankaku-katakana";

    "fcitx5/conf/skk.conf".text = ''
      Rule=custom
    '';
  };
}
