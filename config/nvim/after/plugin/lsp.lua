require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        'lua_ls',
        'clangd',
        'rust_analyzer',
        'pylsp',
    },
})

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    'vim'
                }
            }
        }
    }
})
lspconfig.clangd.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.pylsp.setup({})

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-l>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    })
})

