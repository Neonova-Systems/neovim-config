return {
    "mrjones2014/legendary.nvim",
    priority = 10000,
    lazy = false,
    keys = {
        {
            "<C-p>",
            function()
                -- hover.nvim tags its floating window with this window-local var;
                -- preserve "<C-p> = previous hover source" while that window is focused.
                if vim.w.hover_preview ~= nil then
                    return require("hover").switch("previous")
                end
                require("legendary").find()
            end,
            desc = "Open command palette (previous hover source in hover window)",
        },
    },
    opts = {
        extensions = { lazy_nvim = true },
        funcs = {
            {
                function() require("snacks").lazygit() end,
                description = "Open lazygit (snacks)",
            },
        },
    },
}
