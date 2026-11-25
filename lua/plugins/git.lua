return {
    {
        "nvim-mini/mini-git",
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