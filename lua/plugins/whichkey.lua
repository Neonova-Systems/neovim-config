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
            window = {
                border = "single",
                winblend = 0,
            },
            keys = {
                groups = {
                    ["<leader>f"] = { name = "+find" },
                    ["<leader>g"] = { name = "+git" },
                    ["<leader>l"] = { name = "+lsp" },
                    ["<leader>b"] = { name = "+buffers" },
                    ["<leader>c"] = { name = "+colorscheme" },
                    ["<leader>d"] = { name = "+delete" },
                    ["<leader>e"] = { name = "+explorer" },
                    ["<leader>s"] = { name = "+search" },
                    ["<leader>x"] = { name = "+execute" },
                    ["g"] = { name = "+goto" },
                    ["<C-h>"] = { name = "+harpoon" },
                },
            },
        })
    end,
    keys = {
        -- Glance peek mappings (g-prefix group)
        { "gpd", "<cmd>Glance definitions<CR>", desc = "Glance: Peek Definitions" },
        { "gpr", "<cmd>Glance references<CR>", desc = "Glance: Peek References" },
        { "gpi", "<cmd>Glance implementations<CR>", desc = "Glance: Peek Implementations" },
        { "gpy", "<cmd>Glance type_definitions<CR>", desc = "Glance: Peek Type Definitions" },
    },
}