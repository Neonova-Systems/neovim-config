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
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>grn", true, false, true),
                "n", false)
        end),
        rtxt = "<leader>grn",
    },

    { name = " separator" },

    {
        name = " LSP Actions",
        hl = "ExBlue",
        items = "lsp",
    },

    { name = " separator" },

    {
        name = " Git Actions",
        hl = "ExGreen",
        items = "git",
    },

    { name = " separator" },

    {
        name = " Harpoon",
        hl = "ExYellow",
        items = "harpoon",
    },

    { name = " separator" },

    {
        name = " Picker",
        hl = "ExRed",
        items = "picker",
    },

    { name = " separator" },

    {
        name = " Diagnostics",
        hl = "ExLightGrey",
        items = "diagnostics",
    },
}