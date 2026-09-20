vim.fn['ddu#custom#patch_local']('file_recursive', {
    ui = 'ff',
    sources = {
        {
            name = { 'file_rec' },
            options = {
                matchers = {
                    "matcher_substring",
                },
            },
            params = {
                ignoreDirectories = { 'node_modules', '.git' },
            },
        },
    },
    kindOptions = {
        file = { defaultAction = 'open' },
    },
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'ddu-ff',
    callback = function()
        local opts = { noremap = true, silent = true, buffer = true }
        vim.keymap.set('n', 'q', [[<Cmd>call ddu#ui#do_action("quit")<CR>]], opts)
        vim.keymap.set('n', '<CR>', [[<Cmd>call ddu#ui#do_action("itemAction")<CR>]], opts)
        vim.keymap.set('n', 'i', [[<Cmd>call ddu#ui#do_action("openFilterWindow")<CR>]], opts)
    end,
})

vim.keymap.set('n', '<leader>ff', [[<Cmd>call ddu#start(#{name:"file_recursive"})<CR>]])
