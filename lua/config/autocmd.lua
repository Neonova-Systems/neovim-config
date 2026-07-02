vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.highlight.on_yank({ -- Highlights the yanked text.
            timeout = 150,      -- time in ms before highlight is cleared (default `150`)
            on_macro = true,    -- highlight when executing macro (default `false`)
            on_visual = true    -- highlight when yanking visual selection (default `true`)
        })
    end,
})

-- Binary file editing in hex format
local autocommand_group = vim.api.nvim_create_augroup("binary_edit", { clear = true }) -- Create an autocommand group that will use to store autocommand
local binary_file_pattern = { "*.bin", "*.out", "*.png" }
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = binary_file_pattern, -- Patterns to match against event
    command = "setfiletype xxd | %!xxd",
    group = autocommand_group,     -- Store this autocommand to autocommand_group
    desc = "Open binary in hex format",
})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = binary_file_pattern, -- Patterns to match against event
    command = "%!xxd -r",
    group = autocommand_group,
    desc = "Write hex into binary",
})
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = binary_file_pattern,
    command = "set nomod | %!xxd",
    group = autocommand_group,
    desc = "Convert binary to hex format again after write event",
})

-- Translate mini.diff summaries into a standardized string format for status lines
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniDiffUpdated', -- Fire hook when mini.diff refreshes internal math
    callback = function(data)
        local summary = vim.b[data.buf].minidiff_summary
        if not summary then return end

        local parts = {}
        if summary.add > 0 then table.insert(parts, '+' .. summary.add) end
        if summary.change > 0 then table.insert(parts, '~' .. summary.change) end
        if summary.delete > 0 then table.insert(parts, '-' .. summary.delete) end

        -- Re-bind variable cleanly for statusline reading blocks
        vim.b[data.buf].minidiff_summary_string = table.concat(parts, ' ')
    end,
})

-- Block LSP execution entirely on Git configurations
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "gitrebase" },
    callback = function()
        -- Force-disable completion engines and structural tracking for the buffer
        vim.opt_local.omnifunc = ""

        local clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            vim.lsp.buf_detach(0, client.id)
        end
    end,
})
