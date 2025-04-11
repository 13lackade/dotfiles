require('nvim-treesitter.install').prefer_git = false
require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
})

vim.filetype.add({
    pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
})
