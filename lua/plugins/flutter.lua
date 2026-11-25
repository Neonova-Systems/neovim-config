return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
        "mfussenegger/nvim-dap",  -- required for debugging
    },
    config = function()
        -- flutter-tools 3.2.0 expects dap.listeners.on_session, which exists only on
        -- nvim-dap master; the newest release (0.10.0) lacks it. Without this the
        -- debugger_runner module throws at load and aborts flutter-tools setup.
        -- On 0.10.0 the listener is never invoked, so sessions started through
        -- dap.continue() are not tracked; :FlutterDebug and :FlutterRun still work.
        local ok, dap = pcall(require, "dap")
        if ok and dap.listeners and dap.listeners.on_session == nil then
            dap.listeners.on_session = {}
        end

        require("flutter-tools").setup({
            debugger = {
                enabled = true, -- enable nvim-dap integration
            },
        })
    end,
}
