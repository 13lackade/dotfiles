local M = {}

M.setup = function(self,config)
	vim.g.netrw_liststyle = 0
	vim.g.netrw_banner = 0
	vim.g.netrw_bufsettings = 'nomodifiable nomodified number relativenumber nobuflisted nowrap readonly'
	vim.g.netrw_list_hide = [[^\.\+/$]]

	vim.keymap.set('n','<leader>df',':Ex<CR>')
end

return M
