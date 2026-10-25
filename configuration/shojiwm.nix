{ inputs, ... }:
{
  imports = [ inputs.shojiwm.nixosModules.default ];

  programs.shojiwm = {
    enable = true;
    initConfig.enable = false;
  };
}
