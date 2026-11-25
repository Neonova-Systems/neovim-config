return {
    "pretodev/dart-class-tools.nvim",
    ft = "dart",
    opts = {
        keymaps = {
            -- Actions surface through the existing <leader>ca LSP code-action
            -- picker, so the plugin's own <leader>dc map is disabled to avoid a
            -- 500ms timeout on <leader>d (delete to blackhole register).
            code_action = false,
        },
    },
}
