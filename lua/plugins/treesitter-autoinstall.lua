return {
    "mks-h/treesitter-autoinstall.nvim",
    lazy = false,
    config = function()
        require("treesitter-autoinstall").setup()
    end,
}