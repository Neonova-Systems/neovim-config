return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function()
        require("which-key").setup({
            layout = {
                align = "center",
            },
            win = {
                border = "single",
                winblend = 0,
            },
            spec = {
                { "g",     group = "goto" },
                { "g<Space>", group = "jump (direct)" },
                { "<leader>-", group = "explorer" },

                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>l", group = "lsp" },
                { "<leader>b", group = "buffers" },
                { "<leader>c", group = "colorscheme" },
                { "<leader>d", group = "delete" },
                { "<leader>e", group = "explorer" },
                { "<leader>s", group = "search" },
                { "<leader>x", group = "execute" },
                { "<C-h>", group = "harpoon" },
            },
        })
    end,
}