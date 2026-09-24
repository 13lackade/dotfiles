require('nvim-treesitter').setup({
    install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site/treesitter'),
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = "*",
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
