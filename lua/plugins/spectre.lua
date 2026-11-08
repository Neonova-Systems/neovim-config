return {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
        { "<leader>sr", "<cmd>Spectre<CR>", desc = "Search & Replace across files" },
        { "<leader>sw", function() require("spectre").open_visual_search({ is_open = true }) end, desc = "Search word under cursor" },
    },
    config = function()
        require("spectre").setup({
            default = {
                find_engine = "rg", -- rg (ripgrep) is default
            },
        })
    end,
}