local highlights = {
    Normal = "User1",
    Command = "User2",
    Insert = "User3",
    Terminal = "User3",
    Visual = "User4",
    Replace = "User5",
    Error = "User6",
    Warn = "User7",
    Info = "User8",
    Hint = "user9",
}

local get_mode_highlight = function()
    local map = {
        ["n"]      = "Normal",
        ["no"]     = "O-PENDING",
        ["nov"]    = "O-PENDING",
        ["noV"]    = "O-PENDING",
        ["no\22"] = "O-PENDING",
        ["niI"]    = "Normal",
        ["niR"]    = "Normal",
        ["niV"]    = "Normal",
        ["nt"]     = "Normal",
        ["ntT"]    = "Normal",
        ["v"]      = "Visual",
        ["vs"]     = "Visual",
        ["V"]      = "Visual",
        ["Vs"]     = "Visual",
        ["\22"]   = "Visual",
        ["\22s"]  = "Visual",
        ["s"]      = "SELECT",
        ["S"]      = "S-LINE",
        ["\19"]   = "S-BLOCK",
        ["i"]      = "Insert",
        ["ic"]     = "Insert",
        ["ix"]     = "Insert",
        ["R"]      = "Replace",
        ["Rc"]     = "Replace",
        ["Rx"]     = "Replace",
        ["Rv"]     = "V-REPLACE",
        ["Rvc"]    = "V-REPLACE",
        ["Rvx"]    = "V-REPLACE",
        ["c"]      = "Command",
        ["cv"]     = "EX",
        ["ce"]     = "EX",
        ["r"]      = "Replace",
        ["rm"]     = "MORE",
        ["r?"]     = "CONFIRM",
        ["!"]      = "SHELL",
        ["t"]      = "Terminal",
    }

    local mode_code = vim.api.nvim_get_mode().mode
    if map[mode_code] == nil then
        return highlights.Normal
    else
        return highlights[map[mode_code]]
    end
end

_G.StatusLine = function()
    local severity = {
        Error = vim.diagnostic.severity.ERROR,
        Warn = vim.diagnostic.severity.WARN,
        Info = vim.diagnostic.severity.INFO,
        Hint = vim.diagnostic.severity.HINT,
    }

    local get_count = function(severity)
        local diagnostic = vim.diagnostic.get(nil ,{ severity = severity })
        local count = 0
        for _ in pairs(diagnostic) do count = count + 1 end
        return count
    end

    local FILE_NAME = "%t"
    local MODIFIED = "%m"
    local RIGHT_ALIGNED = "%="

    local statusline = string.format("%%#%s# ",get_mode_highlight())
        .. string.format("%%#StatusLine# %s %s", FILE_NAME, MODIFIED)
        .. RIGHT_ALIGNED
    for _, severity_name in pairs({"Error", "Warn", "Info", "Hint"}) do
        local highlight = string.format("%%#%s#", highlights[severity_name])
        statusline = statusline .. string.format("%s %s:%s ", highlight,
            severity_name:sub(1,1),get_count(severity[severity_name]))
    end
    statusline = statusline .. string.format("%%#%s# ",get_mode_highlight())
    return statusline
end

vim.opt.statusline = "%!v:lua.StatusLine()"
vim.opt.showmode = false

vim.api.nvim_create_autocmd({"ColorScheme"}, {
    callback = function()
        vim.api.nvim_set_hl(0, highlights.Normal, { ctermfg = 0, ctermbg = 4 })
        vim.api.nvim_set_hl(0, highlights.Command, { ctermfg = 0, ctermbg = 3})
        vim.api.nvim_set_hl(0, highlights.Insert, { ctermfg = 0, ctermbg = 2 })
        vim.api.nvim_set_hl(0, highlights.Visual, { ctermfg = 0, ctermbg = 5 })
        vim.api.nvim_set_hl(0, highlights.Replace, { ctermfg = 0, ctermbg = 1 })
        vim.api.nvim_set_hl(0, highlights.Error, { ctermfg = 1, ctermbg = 0 })
        vim.api.nvim_set_hl(0, highlights.Warn, { ctermfg = 11, ctermbg = 0 })
        vim.api.nvim_set_hl(0, highlights.Info, { ctermfg = 14, ctermbg = 0 })
        vim.api.nvim_set_hl(0, highlights.Hint, { ctermfg = 10, ctermbg = 0 })
    end
})
