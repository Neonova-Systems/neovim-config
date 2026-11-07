-- Diagnostics submenu built on vim.diagnostic and the mini.extra picker.

local severity = vim.diagnostic.severity

-- Defer until the menu float is closed and focus is restored.
local function deferred(fn)
    return function() vim.schedule(fn) end
end

return {
    {
        name = "Float at Cursor",
        cmd = vim.diagnostic.open_float,
        rtxt = "<leader>vd",
    },

    {
        name = "All Diagnostics",
        cmd = deferred(function()
            require("mini.extra").pickers.diagnostic { scope = "all" }
        end),
        rtxt = "<leader>xx",
    },

    {
        name = "Buffer Diagnostics",
        cmd = deferred(function()
            require("mini.extra").pickers.diagnostic { scope = "current" }
        end),
    },

    { name = " separator" },

    {
        name = "Next Diagnostic",
        cmd = function() vim.diagnostic.jump { count = 1 } end,
        rtxt = "]d",
    },

    {
        name = "Prev Diagnostic",
        cmd = function() vim.diagnostic.jump { count = -1 } end,
        rtxt = "[d",
    },

    { name = " separator" },

    {
        name = "Errors only",
        cmd = function()
            local cfg = vim.diagnostic.config()
            cfg.virtual_text = not cfg.virtual_text
            vim.diagnostic.config(cfg)
            vim.notify("Diagnostics virtual text: " .. (cfg.virtual_text and "on" or "off"))
        end,
    },

    {
        name = "Set Error Level",
        cmd = function()
            vim.diagnostic.config { float = { severity = severity.ERROR } }
            vim.notify "Diagnostic float severity: Error"
        end,
    },

    {
        name = "Set Warn Level",
        cmd = function()
            vim.diagnostic.config { float = { severity = severity.WARN } }
            vim.notify "Diagnostic float severity: Warning"
        end,
    },
}
