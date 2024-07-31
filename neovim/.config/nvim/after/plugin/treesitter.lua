require('nvim-treesitter.install').prefer_git = true
require('nvim-treesitter.configs').setup({
    ensure_installed = {'bash', 'c', 'diff', 'lua'},
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
})

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
