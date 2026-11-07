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
        name = "Peek Implementations",
        cmd = "Glance implementations",
        rtxt = "gpi",
    },

    { name = " separator" },

    {
        name = "Document Symbols",
        cmd = deferred(function()
            require("mini.extra").pickers.lsp { scope = "document_symbol" }
        end),
        rtxt = "gO",
    },

    {
        name = "Workspace Symbols",
        cmd = deferred(function()
            require("mini.extra").pickers.lsp { scope = "workspace_symbol" }
        end),
        rtxt = "<leader>vws",
    },

    {
        name = "Hover Doc",
        cmd = deferred(function() require("hover").open() end),
        rtxt = "K",
    },

    { name = " separator" },

    {
        name = "Show signature help",
        cmd = vim.lsp.buf.signature_help,
        rtxt = "<C-s>",
    },

    {
        name = "Run CodeLens",
        cmd = vim.lsp.codelens.run,
        rtxt = "grx",
    },

    {
        name = "Add workspace folder",
        cmd = vim.lsp.buf.add_workspace_folder,
    },

    {
        name = "Remove workspace folder",
        cmd = vim.lsp.buf.remove_workspace_folder,
    },
}
