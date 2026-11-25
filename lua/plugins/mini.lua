return {
    "nvim-mini/mini.nvim",
    lazy = false,
    config = function()
        require("mini.bufremove").setup()
        require("mini.comment").setup()
        require("mini.bracketed").setup({
            -- Free the "c" suffix so gitsigns can own [c / ]c for hunk navigation.
            comment = { suffix = "" },
        })
        require("mini.ai").setup()
        require("mini.splitjoin").setup()
        require('mini.operators').setup()
        require("mini.surround").setup({
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                add = 'sa',        -- Add surrounding in Normal and Visual modes
                delete = 'sd',     -- Delete surrounding
                find = 'sf',       -- Find surrounding (to the right)
                find_left = 'sF',  -- Find surrounding (to the left)
                highlight = 'sh',  -- Highlight surrounding
                replace = 'sr',    -- Replace surrounding

                suffix_last = 'l',
                suffix_next = 'n',
            },
        })

        require("mini.extra").setup()

        vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { fg = "#000000", bg = "#325CC0", bold = true })

        vim.keymap.set("n", "<leader>fD", function() require("mini.extra").pickers.diagnostic({ scope = "all" }) end,
            { desc = "Search diagnostics (workspace)" })
    end,
}