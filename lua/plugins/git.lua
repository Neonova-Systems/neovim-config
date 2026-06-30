return {
    {
        "nvim-mini/mini.diff",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.diff").setup({
                mappings = {
                    apply = 'gh', -- Apply hunks inside a visual/operator region
                    reset = 'gH', -- Reset hunks inside a visual/operator region

                    -- Hunk range textobject to be used inside operator
                    -- Works also in Visual mode if mapping differs from apply and reset
                    textobject = 'gh',

                    -- Go to hunk range in corresponding direction
                    goto_first = '[H',
                    goto_prev = '[h',
                    goto_next = ']h',
                    goto_last = ']H',
                },
            })

            local diff = require("mini.diff")
            -- Toggle persistent contextual text area overlay
            vim.keymap.set("n", "<leader>go", function() diff.toggle_overlay(0) end, { desc = "Toggle Git Diff Overlay" })
        end,
    },
    {
        "nvim-mini/mini.git",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.git").setup()

            local mg = require("mini.git")
            -- Context history investigation keymaps
            vim.keymap.set("n", "<leader>gc", function() mg.show_at_cursor() end, { desc = "Show Git data under cursor" })
            vim.keymap.set("x", "<leader>gh", function() mg.show_range_history() end, { desc = "Show line range history logs" })
        end,
    }
}
