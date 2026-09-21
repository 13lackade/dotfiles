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

local get_diagnostics = function()
    local counts = vim.diagnostic.count(0)

    local errors = counts[vim.diagnostic.severity.ERROR] or 0
    local warnings = counts[vim.diagnostic.severity.WARN] or 0
    local info = counts[vim.diagnostic.severity.INFO] or 0
    local hints = counts[vim.diagnostic.severity.HINT] or 0

    return table.concat({
        '%#DiagnosticError#\u{ea87} ' .. errors .. '%*  ',
        '%#DiagnosticWarn#\u{ea6c} ' .. warnings .. '%*  ',
        '%#DiagnosticInfo#\u{eb32} ' .. info .. '%*  ',
        '%#DiagnosticHint#\u{ea74} ' .. hints .. '%*  ',
    })
end

vim.g.customstatusline = function()
    local edge = string.format('%%%i* %%*', mode_color())
    return table.concat({
        edge,
        vim.bo.filetype ~= 'netrw' and ' %t %m' or ' netrw',
        '%=',
        #vim.lsp.get_clients({ bufnr = 0 }) ~= 0 and get_diagnostics() or '',
        edge,
    })
end

vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.statusline = '%!v:lua.vim.g.customstatusline()'
