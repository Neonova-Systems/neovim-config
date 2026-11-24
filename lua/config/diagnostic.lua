local icons = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
}

vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        format = function(diagnostic)
            return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
        end,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.HINT] = icons.Hint,
            [vim.diagnostic.severity.INFO] = icons.Info,
        },
    },
})

vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, { desc = "Show diagnostics in a floating window." })