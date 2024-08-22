require('mason').setup()
require('mason-tool-installer').setup({
    ensure_installed = {
        'texlab',
        'lua_ls',
        'clangd',
        'pyright',
        'cmake',
        'bashls'
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

-- disable LSP syntax highlighting
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>ljn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ljp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>ld', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>ljd', vim.lsp.buf.definition)

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
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
