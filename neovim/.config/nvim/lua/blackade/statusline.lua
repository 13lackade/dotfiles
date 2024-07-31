local M = {}

M.highlights = {
    Normal = 'User1',
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

M.modes = {
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

M.get_mode_highlight = function(self)
    local mode = vim.api.nvim_get_mode().mode
    if self.modes[mode] ~= nil then
        return self.highlights[self.modes[mode]]
    else
        return self.highlights.Normal
    end
end

M.statusline = function(self)
    local FILE_NAME = "%t"
    local MODIFIED = "%m"
    local RIGHT_ALIGN = "%="

    local statusline = 
        string.format("%%#%s# ",self:get_mode_highlight()) ..
        string.format("%%#StatusLine# %s %s", FILE_NAME, MODIFIED) ..
        RIGHT_ALIGN

    if vim.g.blackade_devmode then

    end

    statusline =
        statusline ..
        string.format("%%#%s# ",self:get_mode_highlight())

    return statusline
end

M.setup = function(self,config)
    -- TODO: "%!v:lua.require('blackade.statusline'):statusline()" seems not to work.
    vim.opt.statusline = "%!v:lua.require('blackade.statusline').statusline(v:lua.require('blackade.statusline'))"
    vim.opt.showmode = false

    vim.api.nvim_create_autocmd({"ColorScheme"}, {
        callback = function()
            vim.api.nvim_set_hl(0, self.highlights.Normal, { ctermfg = 0, ctermbg = 4 })
            vim.api.nvim_set_hl(0, self.highlights.Command, { ctermfg = 0, ctermbg = 3})
            vim.api.nvim_set_hl(0, self.highlights.Insert, { ctermfg = 0, ctermbg = 2 })
            vim.api.nvim_set_hl(0, self.highlights.Visual, { ctermfg = 0, ctermbg = 5 })
            vim.api.nvim_set_hl(0, self.highlights.Replace, { ctermfg = 0, ctermbg = 1 })
            vim.api.nvim_set_hl(0, self.highlights.Error, { ctermfg = 1, ctermbg = 0 })
            vim.api.nvim_set_hl(0, self.highlights.Warn, { ctermfg = 11, ctermbg = 0 })
            vim.api.nvim_set_hl(0, self.highlights.Info, { ctermfg = 14, ctermbg = 0 })
            vim.api.nvim_set_hl(0, self.highlights.Hint, { ctermfg = 10, ctermbg = 0 })
        end
    })
end

return M
