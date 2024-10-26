local M = {}

M.setup = function(self,config)
    vim.keymap.set('n', '<leader>sf', ':vnew<CR>:Telescope find_files<CR>')
    vim.keymap.set('n', '<leader>st', ':vnew<CR>:terminal<CR>')
    vim.keymap.set('n', '<leader>ss', ':vnew<CR>')

    vim.keymap.set('i', '<C-@>', '<Nop>')

    vim.keymap.set('v', '<C-k>', function() require('blackade.util').move_block('up') end)
    vim.keymap.set('v', '<C-j>', function() require('blackade.util').move_block('down') end)
end

return M
