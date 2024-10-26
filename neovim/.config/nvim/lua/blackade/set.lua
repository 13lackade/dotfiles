local M = {}

M.setup = function(self,config)
	vim.opt.number = true
	vim.opt.relativenumber = true

	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.expandtab = true

    vim.opt.mouse = ''

	vim.opt.wrap = false

	vim.opt.autoindent = true

	vim.opt.clipboard = 'unnamedplus'

	vim.opt.laststatus = 3
    -- vim.opt.cmdheight = 0

	vim.opt.signcolumn = 'yes'

	vim.opt.colorcolumn = '80'

    vim.opt.hlsearch = true
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    -- Disable commenting when going to a newline from a comment line
    vim.api.nvim_create_autocmd('FileType', {
        callback = function()
            vim.opt.formatoptions:remove('r')
            vim.opt.formatoptions:remove('o')
            vim.opt.formatoptions:remove('c')
        end,
    })

    vim.api.nvim_create_autocmd('TermOpen', {
        callback = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = 'no'

            vim.cmd.startinsert()
        end,
    })

    -- clear write message when write
    vim.api.nvim_create_autocmd('BufWritePost', { command = 'silent w' })

    -- disable '~' on nonexistent lines
    vim.opt.fillchars = { eob = ' ' }

    if vim.g.neovide then
       vim.o.guifont = 'monospace:h12'
    end
end

return M
