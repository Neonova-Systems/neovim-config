return {
    "rachartier/tiny-cmdline.nvim",
    lazy = false,
    config = function()
        require("tiny-cmdline").setup({
            position = {
                y = "20%",
            },
        })
    end,
}