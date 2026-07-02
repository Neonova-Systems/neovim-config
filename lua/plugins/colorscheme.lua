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
    end,
}