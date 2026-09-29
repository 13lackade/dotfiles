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
  xdg.dataFile =
    plug [
      "catppuccin.nvim"
      "nvim-lspconfig"
      "nvim-treesitter"
      "denops.vim"
      "ddu.vim"
      "ddu-ui-ff"
      "ddu-source-file_rec"
      "ddu-filter-matcher_substring"
      "ddu-kind-file"
      "ddc.vim"
      "pum.vim"
      "ddc-around"
      "ddc-matcher_head"
      "ddc-sorter_rank"
      "ddc-converter_remove_overlap"
      "ddc-ui-pum"
      "ddc-source-lsp"
      {
        name = "lean.nvim";
        opt = true;
      }
    ]
    // {
      "nvim/site/treesitter.json".text = builtins.toJSON {
        lean = {
          url = plugins.tree-sitter-lean.src.gitRepoUrl;
          revision = plugins.tree-sitter-lean.src.rev;
          queries = "queries";
          tier = 2;
        };
      };
    };
}
