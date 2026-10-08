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

vim.lsp.config('*', {
    capabilities = require('ddc_source_lsp').make_client_capabilities(),
})

vim.lsp.enable({
    'clangd',
    'lua_ls',
    'pyright',
    'vtsls',
    'html',
    'cssls',
    'jsonls',
})

vim.lsp.semantic_tokens.enable(false)
