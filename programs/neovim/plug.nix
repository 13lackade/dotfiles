{
  lib,
  pkgs,
  plugins,
}:
list:
lib.listToAttrs (
  map (
    item:
    let
      parsed =
        if builtins.isString item then
          {
            name = item;
            opt = false;
          }
        else
          item;
      type = if parsed.opt or false then "opt" else "start";
    in
    {
      name = "nvim/site/pack/nix/${type}/${parsed.name}";
      value = {
        source = pkgs.vimUtils.buildVimPlugin (
          plugins.${parsed.name}
          // {
            doCheck = false;
          }
        );
      };
    }
  ) list
)
