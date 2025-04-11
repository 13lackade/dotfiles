local xdg_bin_home = vim.env.XDG_BIN_HOME
local lspconfig = require('lspconfig')
lspconfig.pyright.setup({
    cmd = { xdg_bin_home .. "/pyright-langserver", "--stdio" },
})
lspconfig.clangd.setup({
    cmd = { xdg_bin_home .. "/clangd" },
})

-- disable LSP syntax highlighting
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>d', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>jn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>jp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>jd', vim.lsp.buf.definition)
