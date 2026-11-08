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
                -- Glance peek mappings (g-prefix group)
                { "gpd", "<cmd>Glance definitions<CR>", desc = "Glance: Peek Definitions" },
                { "gpr", "<cmd>Glance references<CR>", desc = "Glance: Peek References" },
                { "gpi", "<cmd>Glance implementations<CR>", desc = "Glance: Peek Implementations" },
                { "gpy", "<cmd>Glance type_definitions<CR>", desc = "Glance: Peek Type Definitions" },

                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>l", group = "lsp" },
                { "<leader>b", group = "buffers" },
                { "<leader>c", group = "colorscheme" },
                { "<leader>d", group = "delete" },
                { "<leader>e", group = "explorer" },
                { "<leader>s", group = "search" },
                { "<leader>x", group = "execute" },
                { "g",     group = "goto" },
                { "<C-h>", group = "harpoon" },
            },
        })
    end,
}