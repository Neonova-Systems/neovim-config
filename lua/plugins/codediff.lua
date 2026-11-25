return {
    "esmuellert/codediff.nvim",
    lazy = false,
    keys = {
        { "<leader>go", "<cmd>CodeDiff<CR>", desc = "Diff working tree (codediff)" },
    },
    config = function()
        require("codediff").setup({
            explorer = {
                width = 50,
                auto_open_on_cursor = true,
                view_mode = "tree", -- "list" or "tree"
                line_stats = {
                    enabled = true,
                },
            },
            diff = {
                compact = true,
                compact_context_lines = 8,
                compact_sync_folds = true, -- open/close folds in both panes together
            },
            keymaps = {
                view = {},
            },
        })
    end,
}