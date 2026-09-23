{
  pkgs,
  lib,
  symlink,
  dotfiles,
  plugins,
  ...
}:
let
  plug = import ./plug.nix {
    inherit
      lib
      pkgs
      plugins
      ;
  };
in
{
  home.packages = with pkgs; [
    neovim
    ripgrep
    deno
    uv

    tree-sitter
    gcc

    clang-tools
    lua-language-server
    pyright
  ];
  xdg.configFile."nvim" = {
    source = symlink "${dotfiles}/programs/neovim/config";
    recursive = true;
  };
  xdg.dataFile = plug [
    "catppuccin.nvim"
    "nvim-lspconfig"
    "nvim-treesitter"
    "denops.vim"
    "ddu.vim"
    "ddu-ui-ff"
    "ddu-source-file_rec"
    "ddu-filter-matcher_substring"
    "ddu-kind-file"
  ];
}
