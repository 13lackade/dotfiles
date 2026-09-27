vim.api.nvim_create_autocmd({ 'BufReadPre', 'bufNewFile' }, {
    pattern = '*.lean',
    callback = function()
        vim.cmd.packadd('lean.nvim')
        vim.g.lean_config = { mappings = true }
    end,
})
