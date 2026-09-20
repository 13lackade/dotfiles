require('catppuccin').setup({
    flavour = 'mocha',
    custom_highlights = function(colors)
        return {
            User1 = { bg = colors.blue },
            User2 = { bg = colors.mauve },
            User3 = { bg = colors.green },
            User4 = { bg = colors.red },
            User5 = { bg = colors.peach },
        }
    end
})

vim.cmd.colorscheme('catppuccin-nvim')
