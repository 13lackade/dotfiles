require('nvim-treesitter').setup({
    install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site/treesitter')
})
