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
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values
local scan = require('plenary.scandir')
local find_dirs = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = 'Find Directory',
        finder = finders.new_table({
            results = scan.scan_dir('.',{only_dirs = true,respect_gitignore = true })
        }),
        sorter = config.generic_sorter(opts),
    }):find()
end

vim.keymap.set('n', '<leader>fd', find_dirs)
