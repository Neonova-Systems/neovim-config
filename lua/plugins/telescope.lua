return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "debugloop/telescope-undo.nvim",
    },
    cmd = "Telescope",
    keys = {
        { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Lists open buffers in current neovim" },
        { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep Live" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
        { "<leader>fw", function() require("telescope.builtin").live_grep() end, desc = "Find word" },
        { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
        { "<leader>fa", ":Telescope<CR>", desc = "Open Telescope" },
        { "<leader>fu", function() require("telescope").extensions.undo.undo() end, desc = "Open Undotree" },
    },
    config = function()
        local actions = require("telescope.actions")
        local action_state = require('telescope.actions.state')
        local action_layout = require("telescope.actions.layout")
        local previewer_utils = require("telescope.previewers.utils")

        local telescope_custom_actions = {}
        function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
            local picker = action_state.get_current_picker(prompt_bufnr)
            local selected_entry = action_state.get_selected_entry()
            local num_selections = #picker:get_multi_selection()
            if not num_selections or num_selections <= 1 then
                actions.add_selection(prompt_bufnr)
            end
            actions.send_selected_to_qflist(prompt_bufnr)
            vim.cmd("cfdo " .. open_cmd)
        end

        function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
            telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
        end

        function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
            telescope_custom_actions._multiopen(prompt_bufnr, "split")
        end

        function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
            telescope_custom_actions._multiopen(prompt_bufnr, "tabe")
        end

        function telescope_custom_actions.multi_selection_open(prompt_bufnr)
            telescope_custom_actions._multiopen(prompt_bufnr, "edit")
        end

        require('telescope').setup {
            defaults = {
                sorting_strategy = 'ascending',
                selection_strategy = 'reset',
                scroll_strategy = "limit",
                layout_strategy = 'flex',
                layout_config = {
                    bottom_pane = { height = 25, preview_cutoff = 120, prompt_position = "top" },
                    center = { height = 0.4, preview_cutoff = 40, prompt_position = "top", width = 0.5 },
                    cursor = { height = 0.9, preview_cutoff = 40, width = 0.8 },
                    horizontal = { anchor = "center", height = 0.95, mirror = false, prompt_position = "top", width = 0.95, preview_cutoff = 120, preview_width = 100 },
                    vertical = { anchor = "center", height = 0.95, mirror = false, prompt_position = "bottom", width = 0.85, preview_cutoff = 40, preview_height = 30 },
                },
                cycle_layout_list = { "horizontal", "vertical", "cursor", "bottom_pane" },
                winblend = 0,
                wrap_results = false,
                initial_mode = 'insert',
                border = true,
                path_display = { "truncate" },
                borderchars = {
                    prompt = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' },
                    results = { ' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' },
                    preview = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' },
                },
                hl_result_eol = true,
                dynamic_preview_title = true,
                results_title = "Results",
                prompt_title = "Prompt",
                mappings = {
                    n = {
                        ["q"] = actions.close,
                        ["<M-p>"] = action_layout.toggle_preview,
                        ["<C-Down>"] = actions.cycle_history_next,
                        ["<C-Up>"] = actions.cycle_history_prev,
                    },
                    i = {
                        ["jk"] = { "<ESC>", type = "command" },
                        ["<C-n>"] = actions.move_selection_next,
                        ["<C-p>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<M-p>"] = action_layout.toggle_preview,
                        ["<C-a>"] = actions.toggle_all,
                        ["<C-h>"] = "which_key",
                        ["<C-r>"] = action_layout.cycle_layout_next,
                        ["<CR>"] = telescope_custom_actions.multi_selection_open,
                        ["<C-V>"] = telescope_custom_actions.multi_selection_open_vsplit,
                        ["<C-S>"] = telescope_custom_actions.multi_selection_open_split,
                        ["<C-T>"] = telescope_custom_actions.multi_selection_open_tab,
                    },
                },
                history = { limit = 100 },
                cache_picker = { num_pickers = 1, limit_entries = 1000 },
                preview = {
                    timeout = 300,
                    filesize_limit = 20,
                    filetype_hook = function(filepath, bufnr, opts)
                        local excluded_filetypes = vim.tbl_filter(function(filetypes_table)
                            return filepath:match(filetypes_table)
                        end, { ".*%.csv", ".*%.toml", })
                        if not vim.tbl_isempty(excluded_filetypes) then
                            previewer_utils.set_preview_message(bufnr, opts.winid,
                                string.format("I don't like %s files! :P", excluded_filetypes[1]:sub(5, -1)))
                            return false
                        end
                        return true
                    end,
                    treesitter = true,
                    msg_bg_fillchar = " ",
                    hide_on_startup = false,
                },
                vimgrep_arguments = {
                    "rg", "--follow", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "--glob", "!.git/*", "--trim",
                },
                color_devicons = true,
                file_ignore_patterns = { "node_modules", "@girs" },
            },
            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                undo = {},
            }
        }
        require("telescope").load_extension("ui-select")
        require("telescope").load_extension("undo")
    end,
}
