return {
    'mcncl/alabaster.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('alabaster').setup({
            style = "dark",          -- "light" or "dark"
            transparent = true,      -- Enable transparent background
            italic_comments = false,  -- Enable italic comments
        })

        vim.cmd.colorscheme('alabaster')
        vim.keymap.set('n', '<leader>c', function()
            require("alabaster").setup({ style = require("alabaster").config.style == "dark" and "light" or "dark" })
        end, { noremap = true, silent = true, desc = "Toggle Alabaster style (light / dark)" })
        vim.keymap.set('n', '<leader>ct', '<cmd>lua require("alabaster").setup({ transparent = not require("alabaster").config.transparent })<CR>', { noremap = true, silent = true, desc = "Toggle Alabaster transparency" })
    end,
}