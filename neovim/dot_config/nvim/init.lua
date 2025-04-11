-- check neovim version
if vim.fn.has('nvim-0.11') ~= 1 then
    vim.notify(
        'neovim version is lower than 0.11 which this config does not' .. 
        ' support, no configuration is done.',
        vim.log.levels.ERROR
    )
    return
else
    vim.loader.enable()
end

require('blackade').setup()
