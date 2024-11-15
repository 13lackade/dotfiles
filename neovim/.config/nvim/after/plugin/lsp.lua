require('mason').setup()
require('mason-tool-installer').setup({
    ensure_installed = {
        'texlab',
        'lua_ls',
        'clangd',
        'pyright',
        'cmake',
        'bashls',
        'ruby_lsp',
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
lspconfig.clangd.setup({})
lspconfig.cmake.setup({})
lspconfig.pyright.setup({})
lspconfig.bashls.setup({})
lspconfig.texlab.setup({})
lspconfig.ruby_lsp.setup({})
lspconfig.hls.setup({})

-- disable LSP syntax highlighting
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
    {desc = 'Show diagnostics in a floating window.'})
vim.keymap.set('n', '<leader>d', vim.lsp.buf.hover,
    {desc = 'Displays hover information about the symbol under the cursor in a floating window.'})
vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help,
    {desc = 'Displays signature information about the symbol under the cursor in a floating window.'})
vim.keymap.set('n', '<leader>jn', vim.diagnostic.goto_next,
    {desc = 'Move to the next diagnostic.'})
vim.keymap.set('n', '<leader>jp', vim.diagnostic.goto_prev,
    {desc = 'Move to the previous diagnostic in the current buffer.'})
vim.keymap.set('n', '<leader>jd', vim.lsp.buf.definition,
    {desc = 'Jumps to the definition of the symbol under the cursor.'})

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    -- { name = "buffer" },
    -- { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
})

require("fidget").setup({})
