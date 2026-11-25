return {
    "folke/snacks.nvim",
    lazy = false,
    config = function()
        require("snacks").setup({
            indent = { enabled = true },
            scroll = { enabled = false },
            picker = {
                enabled = true,
                sources = {
                    files = { hidden = true },
                    grep = { hidden = true },
                },
            },
            notifier = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            image = { enabled = true },
            lazygit = {
                enabled = true,
                configure = true, -- auto-sets nvim-remote preset & syncs theme
            },
        })
    end,
}