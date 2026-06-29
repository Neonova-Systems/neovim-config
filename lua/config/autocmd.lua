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
local autocommand_group = vim.api.nvim_create_augroup("binary_edit", {clear = true}) -- Create an autocommand group that will use to store autocommand
local binary_file_pattern = {"*.bin", "*.out", "*.png"}
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = binary_file_pattern, -- Patterns to match against event
    command = "setfiletype xxd | %!xxd",
    group = autocommand_group, -- Store this autocommand to autocommand_group
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