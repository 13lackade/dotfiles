local M = {}

-- TODO: make it safe
M.safe_setup = function(self,module,config)
    require(module):setup(config)
end

M.setup = function(self,config)
    if vim.env['BLACKADE_DEVMODE'] ~= nil then
        vim.g.blackade_devmode = true
    end

    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    self:safe_setup('blackade.netrw',{})
    self:safe_setup('blackade.set',{})
    self:safe_setup('blackade.keymap',{})
    self:safe_setup('blackade.statusline',{})

    vim.api.nvim_create_user_command(
        'ReloadConfig',
        function() require('blackade'):setup({}) end,
        {})
end

return M
