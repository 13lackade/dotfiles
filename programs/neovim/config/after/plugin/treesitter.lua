require('nvim-treesitter').setup({
    install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site/treesitter'),
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
        local parser_config_path = vim.fs.joinpath(
            vim.fn.stdpath('data'),
            'site/treesitter.json')
        local parser_sources = vim.json.decode(
            table.concat(vim.fn.readfile(parser_config_path), '\n'))

        require('nvim-treesitter.parsers').lean = {
            install_info = {
                url = parser_sources.lean.url,
                revision = parser_sources.lean.revision,
                queries = parser_sources.lean.queries,
            },
            tier = parser_sources.lean.tier,
        }
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = "*",
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
