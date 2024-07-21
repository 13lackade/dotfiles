local M = {}

M.setup = function(self)
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
end

return M
