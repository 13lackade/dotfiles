local M = {}

M.highlights = {
    Normal = 'User1',
    Command = 'User2',
    Insert = 'User3',
    Terminal = 'User3',
    Visual = 'User4',
    Replace = 'User5',
    Error = 'User6',
    Warn = 'User7',
    Info = 'User8',
    Hint = 'User9',
}

M.modes = {
    ['n']      = 'Normal',
    ['no']     = 'O-PENDING',
    ['nov']    = 'O-PENDING',
    ['noV']    = 'O-PENDING',
    ['no\22']  = 'O-PENDING',
    ['niI']    = 'Normal',
    ['niR']    = 'Normal',
    ['niV']    = 'Normal',
    ['nt']     = 'Normal',
    ['ntT']    = 'Normal',
    ['v']      = 'Visual',
    ['vs']     = 'Visual',
    ['V']      = 'Visual',
    ['Vs']     = 'Visual',
    ['\22']    = 'Visual',
    ['\22s']   = 'Visual',
    ['s']      = 'SELECT',
    ['S']      = 'S-LINE',
    ['\19']    = 'S-BLOCK',
    ['i']      = 'Insert',
    ['ic']     = 'Insert',
    ['ix']     = 'Insert',
    ['R']      = 'Replace',
    ['Rc']     = 'Replace',
    ['Rx']     = 'Replace',
    ['Rv']     = 'V-REPLACE',
    ['Rvc']    = 'V-REPLACE',
    ['Rvx']    = 'V-REPLACE',
    ['c']      = 'Command',
    ['cv']     = 'EX',
    ['ce']     = 'EX',
    ['r']      = 'Replace',
    ['rm']     = 'MORE',
    ['r?']     = 'CONFIRM',
    ['!']      = 'SHELL',
    ['t']      = 'Terminal',
}

M.get_mode_highlight = function()
    local mode = vim.api.nvim_get_mode().mode
    local modes = require('blackade.statusline').modes
    local highlights = require('blackade.statusline').highlights

    if modes[mode] ~= nil then
        return highlights[modes[mode]]
    else
        return highlights.Normal
    end
end

M.statusline = function()
    local FILE_NAME = "%t"
    local MODIFIED = "%m"
    local RIGHT_ALIGN = "%="

    local status = require('blackade.statusline')

    local statusline =
        string.format("%%#%s# ",status.get_mode_highlight()) ..
        string.format("%%#StatusLine# %s %s", FILE_NAME, MODIFIED) ..
        RIGHT_ALIGN

    local severities = {'Error', 'Warn', 'Info', 'Hint'}
    for _, severity in ipairs(severities) do
        statusline =
            statusline ..
            string.format("%%#%s#%s %d ",
                status.highlights[severity],
                string.sub(severity, 1, 1),
                #vim.diagnostic.get(0, 
                {severity = vim.diagnostic.severity[string.upper(severity)]}))
    end

    local statusline =
        statusline ..
        string.format("%%#%s# ",status.get_mode_highlight())

    return statusline
end

M.setup = function()
    vim.opt.statusline = "%!v:lua.require('blackade.statusline').statusline()"
    vim.opt.showmode = false
end

return M
