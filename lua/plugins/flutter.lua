return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
        "mfussenegger/nvim-dap",  -- required for debugging
    },
    config = function()
        require("flutter-tools").setup({
            debugger = {
                enabled = true, -- enable nvim-dap integration
            },
        })
    end,
}
