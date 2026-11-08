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

        -- Alabaster's dark theme paints almost every code element with the same
        -- fg color (#CECECE), so treesitter output looks flat. Add distinct
        -- colors for the common capture groups so syntax actually reads.
        local ts = {
            ["@keyword"]              = { fg = "#E06C75" },
            ["@keyword.function"]     = { fg = "#E06C75" },
            ["@keyword.return"]       = { fg = "#E06C75" },
            ["@keyword.operator"]     = { fg = "#E06C75" },
            ["@keyword.condition"]    = { fg = "#E06C75" },
            ["@type"]                 = { fg = "#6199D9" },
            ["@type.builtin"]         = { fg = "#6199D9" },
            ["@type.definition"]      = { fg = "#6199D9" },
            ["@function"]             = { fg = "#98C379" },
            ["@function.builtin"]     = { fg = "#98C379" },
            ["@function.call"]        = { fg = "#98C379" },
            ["@function.method.call"] = { fg = "#98C379" },
            ["@method.call"]          = { fg = "#98C379" },
            ["@variable"]             = { fg = "#E5C07B" },
            ["@variable.builtin"]     = { fg = "#E06C75" },
            ["@variable.parameter"]   = { fg = "#E5C07B" },
            ["@variable.member"]      = { fg = "#E5C07B" },
            ["@property"]             = { fg = "#E5C07B" },
            ["@constant"]             = { fg = "#B77FDB" },
            ["@constant.builtin"]     = { fg = "#B77FDB" },
            ["@string"]               = { fg = "#91B362" },
            ["@string.escape"]        = { fg = "#91B362" },
            ["@number"]               = { fg = "#B77FDB" },
            ["@boolean"]              = { fg = "#B77FDB" },
            ["@operator"]             = { fg = "#999999" },
            ["@punctuation.delimiter"] = { fg = "#999999" },
            ["@punctuation.bracket"]  = { fg = "#999999" },
            ["@comment"]              = { fg = "#6B7678", italic = false },
            ["@module"]               = { fg = "#6199D9" },
            ["@namespace"]            = { fg = "#6199D9" },
            ["@constructor"]          = { fg = "#6199D9" },
            ["@tag"]                  = { fg = "#6199D9" },
        }
        for group, settings in pairs(ts) do
            vim.api.nvim_set_hl(0, group, settings)
        end

        vim.keymap.set('n', '<leader>c', function()
            require("alabaster").setup({ style = require("alabaster").config.style == "dark" and "light" or "dark" })
        end, { noremap = true, silent = true, desc = "Toggle Alabaster style (light / dark)" })
        vim.keymap.set('n', '<leader>ct', '<cmd>lua require("alabaster").setup({ transparent = not require("alabaster").config.transparent })<CR>', { noremap = true, silent = true, desc = "Toggle Alabaster transparency" })
    end,
}