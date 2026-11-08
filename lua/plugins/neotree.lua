return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<leader>e", "<cmd>Neotree toggle reveal_force_cwd<CR>", desc = "Toggle file explorer" },
        { "<leader>E", "<cmd>Neotree focus<CR>",            desc = "Focus file explorer" },
        { "-",         "<cmd>Neotree toggle reveal_force_cwd<CR>", desc = "Toggle file explorer" },
        { "<leader>-", "<cmd>Neotree toggle reveal<CR>",           desc = "Reveal current file in explorer" },
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            window = {
                position = "left",
                width = 38,
                mappings = {
                    ["<space>"] = "toggle_node",
                },
            },
            source_selector = {
                winbar = true,
                sources = {
                    { source = "filesystem", display_name = " 󰉓 Files " },
                    { source = "buffers",   display_name = " 󰈚 Buffers " },
                    { source = "git_status", display_name = " 󰊢 Git " },
                },
            },
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                hijack_netrw_behavior = "open_default",
                filtered_items = {
                    visible = false,
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_ignored = true,
                    hide_by_name = {
                        ".DS_Store",
                        "thumbs.db",
                    },
                    never_show = {
                        ".git",
                    },
                },
                window = {
                    mappings = {
                        -- mini.files defaults
                        ["h"]     = "navigate_up",
                        ["l"]     = "toggle_node",
                        ["H"]     = "go_out_plus",
                        ["<CR>"]  = "open",
                        ["s"]     = "open_vsplit",
                        ["v"]     = "open_split",
                        ["t"]     = "open_tabnew",
                        ["a"]     = "add",
                        ["A"]     = "add_directory",
                        ["d"]     = "delete",
                        ["r"]     = "rename",
                        ["c"]     = "copy",
                        ["m"]     = "move",
                        ["p"]     = "paste_from_clipboard",
                        ["y"]     = "copy_to_clipboard",
                        ["x"]     = "cut_to_clipboard",
                        ["R"]     = "refresh",
                        ["."]    = "toggle_hidden",
                        ["q"]    = "close_window",
                        ["?"]    = "show_help",
                        ["/"]    = "fuzzy_finder",
                        ["#"]    = "fuzzy_sorter",
                    },
                },
            },
            buffers = {
                follow_current_file = { enabled = true },
            },
            git_status = {
                follow_current_file = { enabled = true },
            },
        })
    end,
}