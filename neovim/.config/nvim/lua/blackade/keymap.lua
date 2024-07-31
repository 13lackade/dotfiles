local M = {}

M.setup = function(self,config)
    vim.keymap.set('n', '<leader>sf', ':vnew<CR>:Telescope find_files<CR>')
    vim.keymap.set('n', '<leader>st', ':vnew<CR>:terminal<CR>')
    vim.keymap.set('n', '<leader>ss', ':vnew<CR>')
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>')

    vim.keymap.set('i', '<C-@>', '<Nop>')

    vim.keymap.set('v', 'K', function() require('blackade.util').move_block('up') end)
    vim.keymap.set('v', 'J', function() require('blackade.util').move_block('down') end)
end

return M
