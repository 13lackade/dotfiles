local M = {}

M.setup = function()
    vim.opt.number = true
    vim.opt.relativenumber = true

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true

    vim.opt.mouse = ''

    vim.opt.autoindent = true

    vim.opt.clipboard = 'unnamedplus'

    vim.opt.laststatus = 3

    vim.opt.signcolumn = 'yes'

    vim.opt.colorcolumn = '80'

    vim.opt.hlsearch = true
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    vim.opt.exrc = true
end

return M
