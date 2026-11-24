return {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("solarized-osaka").setup({
            style = "vivid",
            transparent = true,
        })

        vim.cmd.colorscheme("solarized-osaka")

        require("mini.icons").setup()
        require("mini.icons").mock_nvim_web_devicons()
    end,
}