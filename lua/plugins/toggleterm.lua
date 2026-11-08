return {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermSelect", "TermNew", "TermGitPush", "TermGitPushF" },
    config = function()
        require("toggleterm").setup({
            -- Floating terminal window
            direction = "float",
            float_opts = {
                border = "single",
                winblend = 0,
                width = function()
                    return math.floor(vim.o.columns * 0.85)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.85)
                end,
            },
            close_on_exit = true,
            start_in_insert = false,
            persist_size = true,
            persist_mode = true,
            -- Darken the terminal background so it reads differently from code
            shade_terminals = false,
            -- Lazygit as a named, hidden terminal so it isn't toggled by <c-\>
            -- but is reachable via its own keymap.
            terminal = {
                winbar = {
                    enabled = false,
                },
            },
        })
    end,
    keys = {
        { "<leader>gt", "<cmd>ToggleTerm<CR>", desc = "Toggle floating terminal" },
        { "<leader>gl", "<cmd>lua require('config.actions').lazygit()<CR>", desc = "Open lazygit in floating terminal" },
    },
}