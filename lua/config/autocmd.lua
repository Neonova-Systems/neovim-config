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

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.lsp.document_color.enable(true, { bufnr = ev.buf })
    end,
})

-- Highlight the current line only on the active buffer
local cursorline_group = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = cursorline_group,
    pattern = "*",
    command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = cursorline_group,
    pattern = "*",
    command = "setlocal nocursorline",
})

-- Custom filetypes
vim.filetype.add({
    extension = {
        mjml = "html",
    },
})

-- Kitty: mark this window as an editor so kitty releases keys that conflict
-- with Neovim (ctrl+shift+o is kitty's URL-hints shortcut). kitty.conf uses
-- --when-focus-on var:in_editor to unmap that key only while this is set.
if vim.env.KITTY_WINDOW_ID then
    local function kitty_set_editor(value)
        local escaped = "\x1b]1337;SetUserVar=in_editor"
            .. (value and ("=" .. value) or "")
            .. "\x07"
        -- nvim_ui_send exists on the TTY UI; headless has no UI, so fall back.
        local ok = pcall(vim.api.nvim_ui_send, escaped)
        if not ok then
            io.stdout:write(escaped)
        end
    end

    local kitty_group = vim.api.nvim_create_augroup("KittyEditorVar", { clear = true })
    vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
        group = kitty_group,
        callback = function() kitty_set_editor("MQ==") end, -- base64("1")
    })
    vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
        group = kitty_group,
        callback = function() kitty_set_editor(nil) end,
    })
end
