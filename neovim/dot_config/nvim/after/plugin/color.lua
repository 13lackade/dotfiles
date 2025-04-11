require('catppuccin').setup({
    flavour = 'mocha',
    transparent_background = true,
    custom_highlights = function(colors)
        return {
            StatusLine = { bg = colors.surface0 },
            Pmenu = { bg = colors.surface0 },
            TelescopeNormal = { bg = colors.surface0 },
            TelescopeBorder = { bg = colors.surface0 },
            TelescopeSelection = { bg = colors.surface1 },
            TelescopeSelectionCaret = { bg = colors.surface1 },
            TelescopeTitle = { bg = colors.blue, fg = colors.surface0 },
        }
    end
})

vim.api.nvim_create_autocmd({'ColorScheme'}, {
    callback = function()
        highlights = require('blackade.statusline').highlights
        colors = require('catppuccin.palettes').get_palette('mocha')

        vim.api.nvim_set_hl(0, highlights.Normal, { bg = colors.blue })
        vim.api.nvim_set_hl(0, highlights.Command, { bg = colors.peach })
        vim.api.nvim_set_hl(0, highlights.Insert, { bg = colors.green })
        vim.api.nvim_set_hl(0, highlights.Visual, { bg = colors.mauve })
        vim.api.nvim_set_hl(0, highlights.Replace, { bg = colors.red })

        vim.api.nvim_set_hl(0, highlights.Error, { link = 'DiagnosticSignError' })
        vim.api.nvim_set_hl(0, highlights.Warn, { link = 'DiagnosticSignWarn' })
        vim.api.nvim_set_hl(0, highlights.Info, { link = 'DiagnosticSignInfo' })
        vim.api.nvim_set_hl(0, highlights.Hint, { link = 'DiagnosticSignHint' })
    end
})

vim.cmd.colorscheme('catppuccin')
