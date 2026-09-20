local mode_color = function()
    local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
    local mode_colors = {
        n     = 1,
        v     = 2, V = 2, ['\x16'] = 2,
        s     = 5, S = 5, ['\x13'] = 5,
        i     = 3,
        R     = 4,
        c     = 5,
        r     = 5,
        ['!'] = 3, t = 3,
    }

    return mode_colors[mode] or 1
end

vim.g.customstatusline = function()
    local edge = string.format('%%%i* %%*', mode_color())
    return table.concat({
        edge,
        vim.bo.filetype ~= 'netrw' and ' %t %m' or ' netrw',
        '%=',
        edge,
    })
end

vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.statusline = '%!v:lua.vim.g.customstatusline()'
