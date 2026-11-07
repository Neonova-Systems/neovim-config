-- LSP submenu. Matches the keymaps in lua/plugins/lsp.lua; the peek actions
-- route through glance.nvim so the buffer is not left, and the symbol searches
-- through mini.extra.

-- Defer until the menu float is closed: these open windows or send requests.
local function deferred(fn)
    return function() vim.schedule(fn) end
end

return {
    {
        name = "Goto Definition",
        cmd = vim.lsp.buf.definition,
        rtxt = "gd",
    },

    {
        name = "Goto Declaration",
        cmd = vim.lsp.buf.declaration,
        rtxt = "gD",
    },

    {
        name = "Goto Implementation",
        cmd = vim.lsp.buf.implementation,
        rtxt = "gri",
    },

    {
        name = "Goto Type Definition",
        cmd = vim.lsp.buf.type_definition,
        rtxt = "grt",
    },

    { name = " separator" },

    {
        name = "Peek Definitions",
        cmd = "Glance definitions",
        rtxt = "gpd",
    },

    {
        name = "Peek References",
        cmd = "Glance references",
        rtxt = "gpr",
    },

    {
        name = "Peek Type Definitions",
        cmd = "Glance type_definitions",
        rtxt = "gpt",
    },

    {
        name = "Peek Implementations",
        cmd = "Glance implementations",
        rtxt = "gpi",
    },

    { name = " separator" },

    {
        name = "Document Symbols",
        cmd = function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end,
        rtxt = "gO",
    },

    {
        name = "Workspace Symbols",
        cmd = function() require("mini.extra").pickers.lsp({ scope = "workspace_symbol" }) end,
        rtxt = "gW",
    },

    { name = " separator" },

    {
        name = "Show Signature Help",
        cmd = vim.lsp.buf.signature_help,
        rtxt = "gh",
    },

    {
        name = "Format Buffer",
        cmd = function()
            local ok, conform = pcall(require, "conform")
            if ok then conform.format({ lsp_fallback = true }) else vim.lsp.buf.format() end
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

    {
        name = "Restart LSP",
        cmd = ":LspRestart",
        rtxt = "lr",
    },
}