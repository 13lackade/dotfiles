require('telescope').setup({
    pickers = {
        find_files = {
            hidden = true,
            disable_devicons = true,
        },
        colorscheme = {
            enable_preview = true,
        },
    },
    defaults = {
        borderchars = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
    }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
