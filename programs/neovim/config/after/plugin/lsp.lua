vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '\u{ea87}',
            [vim.diagnostic.severity.WARN] = '\u{ea6c}',
            [vim.diagnostic.severity.HINT] = '\u{eb32}',
            [vim.diagnostic.severity.INFO] = '\u{ea74}',
        },
    },
})

vim.lsp.enable({
    'clangd',
    'lua_ls',
    'pyright',
})

vim.lsp.semantic_tokens.enable(false)
