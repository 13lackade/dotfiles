require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "cmake",},
    highlight = {
        enable = true,
    },
})
