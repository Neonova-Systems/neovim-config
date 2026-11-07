-- Root context menu, opened by <C-t> / <RightMouse> / :Menu.
-- Item keys: name, cmd (string | function), rtxt (right-aligned label, doubles
-- as the in-menu hotkey), hl, items (nested submenu table or menus.* module
-- name), title. Rendering lives in lua/menu/ui.lua.

-- Run fn after the menu float is fully closed and focus is restored.
local function deferred(fn)
    return function() vim.schedule(fn) end
end

return {
    {
        name = "Format Buffer",
        cmd = function()
            local ok, conform = pcall(require, "conform")

            if ok then
                conform.format { lsp_fallback = true }
            else
                vim.lsp.buf.format()
            end
        end,
        rtxt = "<leader>f",
    },

    {
        name = "Code Actions",
        cmd = deferred(function() require("actions-preview").code_actions() end),
        rtxt = "<leader>ca",
    },

    {
        name = "Rename Symbol",
        cmd = deferred(function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>grn", true, false, true), "n", false)
        end),
        rtxt = "<leader>grn",
    },

    { name = " separator" },

    {
        name = "LSP Actions",
        hl = "ExBlue",
        items = "lsp",
    },

    {
        name = "Git",
        hl = "ExGreen",
        items = "git",
    },

    {
        name = "Harpoon",
        hl = "ExYellow",
        items = "harpoon",
    },

    {
        name = "Pickers",
        items = "picker",
    },

    {
        name = "Diagnostics",
        hl = "ExRed",
        items = "diagnostics",
    },

    { name = " separator" },

    {
        name = "Edit Config",
        cmd = function()
            vim.cmd "tabnew"
            local conf = vim.fn.stdpath "config"
            vim.cmd("tcd " .. conf .. " | e init.lua")
        end,
        rtxt = "ed",
    },

    {
        name = "Copy Content",
        cmd = "%y+",
        rtxt = "yc",
    },

    {
        name = "Delete Content",
        cmd = "%d",
        rtxt = "dc",
    },

    { name = " separator" },

    {
        name = "Open in terminal",
        hl = "ExRed",
        cmd = function()
            local old_buf = require("menu.state").old_data.buf
            local old_buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(old_buf), ":h")

            vim.cmd "enew"
            vim.fn.termopen { vim.o.shell, "-c", "cd " .. vim.fn.shellescape(old_buf_dir) .. " ; " .. vim.o.shell }
        end,
    },

    {
        name = "Color Schemes",
        cmd = deferred(function() require("mini.extra").pickers.colorschemes() end),
    },
}
