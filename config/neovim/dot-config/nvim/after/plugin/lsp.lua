require('mason').setup()
require('mason-tool-installer').setup({
    ensure_installed = {
        'texlab',
        'lua_ls',
        'clangd',
        'pylsp',
    },
})

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    }
})

-- Disable LSP syntax highlighting
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})
