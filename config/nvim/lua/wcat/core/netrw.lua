vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
vim.g.netrw_list_hide = [[^\.\+/$]]

vim.api.nvim_set_keymap('n','<leader>vd',':Ex<CR>',{noremap = true})
