local patch_global = vim.fn['ddc#custom#patch_global']

patch_global('ui', 'pum')
patch_global('sources', { 'around', 'lsp' })
patch_global('sourceOptions', {
    _ = {
        matchers = { 'matcher_head' },
        sorters = { 'sorter_rank' },
        converters = { 'converter_remove_overlap' },
    },
    lsp = {
        mark = 'LSP',
        isVolatile = true,
        forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
    },
    around = { mark = 'A' },
})

local snippet_engine = vim.fn['denops#callback#register'](function(body)
    vim.snippet.expand(body)
end)

patch_global('sourceParams', {
    lsp = {
        snippetEngine = snippet_engine,
        enableResolveItem = true,
        enableAdditionalTextEdit = true,
    },
})

vim.fn['ddc#enable']()

vim.keymap.set('i', '<C-n>', function()
    vim.fn['pum#map#insert_relative'](1)
end)

vim.keymap.set('i', '<C-p>', function()
    vim.fn['pum#map#insert_relative'](-1)
end)

vim.keymap.set('i', '<C-y>', function()
    vim.fn['pum#map#confirm']()
end)

vim.keymap.set('i', '<C-e>', function()
    vim.fn['pum#map#cancel']()
end)
