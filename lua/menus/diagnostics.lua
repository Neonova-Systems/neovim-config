-- Diagnostics submenu. Uses vim.diagnostic and mini.extra pickers.

local function deferred(fn)
    return function() vim.schedule(fn) end
end

return {
    {
        name = "Document Diagnostics",
        cmd = function() require("mini.extra").pickers.diagnostic({ scope = "current" }) end,
        rtxt = "dd",
    },

    {
        name = "Workspace Diagnostics",
        cmd = function() require("mini.extra").pickers.diagnostic({ scope = "all" }) end,
        rtxt = "dD",
    },

    { name = " separator" },

    {
        name = "Next Diagnostic",
        cmd = function() vim.diagnostic.goto_next({ float = false }) end,
        rtxt = "]d",
    },

    {
        name = "Prev Diagnostic",
        cmd = function() vim.diagnostic.goto_prev({ float = false }) end,
        rtxt = "[d",
    },

    {
        name = "Next Error",
        cmd = function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = false }) end,
        rtxt = "]e",
    },

    {
        name = "Prev Error",
        cmd = function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = false }) end,
        rtxt = "[e",
    },

    { name = " separator" },

    {
        name = "Open Float",
        cmd = vim.diagnostic.open_float,
        rtxt = "gk",
    },

    {
        name = "Set Loclist",
        cmd = vim.diagnostic.setloclist,
        rtxt = "dl",
    },

    {
        name = "Set Qflist",
        cmd = vim.diagnostic.setqflist,
        rtxt = "dq",
    },

    { name = " separator" },

    {
        name = "Toggle Virtual Text",
        cmd = function()
            local cfg = vim.diagnostic.config()
            local vt = cfg and cfg.virtual_text
            vim.diagnostic.config({ virtual_text = not vt })
            vim.notify("Virtual text: " .. (not vt and "on" or "off"))
        end,
        rtxt = "dt",
    },

    {
        name = "Toggle Underline",
        cmd = function()
            local cfg = vim.diagnostic.config()
            local ul = cfg and cfg.underline
            vim.diagnostic.config({ underline = not ul })
            vim.notify("Underline: " .. (not ul and "on" or "off"))
        end,
        rtxt = "du",
    },
}