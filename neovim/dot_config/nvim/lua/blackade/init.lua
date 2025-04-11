local M = {}

M.setup = function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    require('blackade.netrw').setup()
    require('blackade.set').setup()
    require('blackade.statusline').setup()
    require('blackade.keymap').setup()
end

return M
