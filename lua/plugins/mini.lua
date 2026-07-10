return {
    "nvim-mini/mini.nvim",
    version = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        require("mini.bufremove").setup()
        require("mini.comment").setup()
        require("mini.pairs").setup()
        require("mini.bracketed").setup()
        require("mini.ai").setup()
        require("mini.splitjoin").setup()
        require('mini.operators').setup()
        require("mini.cmdline").setup({ autocomplete = { enable = true, delay = 150 }, autocorrect = { enable = false } })
        require("mini.surround").setup({
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                add = 'sa',        -- Add surrounding in Normal and Visual modes
                delete = 'sd',     -- Delete surrounding
                find = 'sf',       -- Find surrounding (to the right)
                find_left = 'sF',  -- Find surrounding (to the left)
                highlight = 'sh',  -- Highlight surrounding
                replace = 'sr',    -- Replace surrounding

                suffix_last = 'l', -- Suffix to search with "prev" method
                suffix_next = 'n', -- Suffix to search with "next" method
            },
        })
        require("mini.files").setup({
            mappings = {
                close = '<Esc>',
                go_in = "<CR>",
                go_in_plus = "L",
                go_out = "_",
                go_out_plus = "H",
            }
        })
        require("mini.notify").setup({
            content = {
                format = function(notif) return notif.msg end, -- only show messages
            }
        })
        require("mini.pick").setup({
            mappings = {
                caret_left        = '<Left>',
                caret_right       = '<Right>',

                choose            = '<CR>',
                choose_in_split   = '<C-s>',
                choose_in_tabpage = '<C-t>',
                choose_in_vsplit  = '<C-v>',
                choose_marked     = '<M-CR>',

                delete_char       = '<BS>',
                delete_char_right = '<Del>',
                delete_left       = '<C-u>',
                delete_word       = '<C-w>',

                mark              = '<C-x>',
                mark_all          = '<C-a>',

                move_down         = '<C-j>',
                move_start        = '<C-g>',
                move_up           = '<C-k>',

                paste             = '<C-r>',

                refine            = '<C-Space>',
                refine_marked     = '<M-Space>',

                scroll_down       = '<C-f>',
                scroll_left       = '<C-h>',
                scroll_right      = '<C-l>',
                scroll_up         = '<C-b>',

                stop              = '<Esc>',

                toggle_info       = '<S-Tab>',
                toggle_preview    = '<Tab>',
            },
        })
        require("mini.extra").setup()
        require("mini.cursorword").setup()
        require("mini.jump2d").setup()
        require('mini.indentscope').setup({ symbol = "│", options = { try_as_border = true }, })
        local miniclue = require('mini.clue')
        miniclue.setup({
            triggers = {
                -- Leader triggers
                { mode = { 'n', 'x' }, keys = '<Leader>' },

                -- `[` and `]` keys
                { mode = 'n',          keys = '[' },
                { mode = 'n',          keys = ']' },

                -- Built-in completion
                { mode = 'i',          keys = '<C-x>' },

                -- `g` key
                { mode = { 'n', 'x' }, keys = 'g' },

                -- Marks
                { mode = { 'n', 'x' }, keys = "'" },
                { mode = { 'n', 'x' }, keys = '`' },

                -- Registers
                { mode = { 'n', 'x' }, keys = '"' },
                { mode = { 'i', 'c' }, keys = '<C-r>' },

                -- Window commands
                { mode = 'n',          keys = '<C-w>' },

                -- `z` key
                { mode = { 'n', 'x' }, keys = 'z' },
            },

            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                miniclue.gen_clues.square_brackets(),
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
            window = {
                config = { width = math.floor(vim.o.columns * 0.33) },
                delay = 734, -- Delay before showing clue window
                scroll_down = '<C-d>',
                scroll_up = '<C-u>',
            }
        })
        require("mini.completion").setup({
            lsp_completion = {
                auto_setup = true,
                process_time = function(items, base)
                    return require("mini.completion").default_process_items(items, base, { filtersort = "fuzzy", })
                end,
            }
        })
        require("mini.snippets").setup({
            snippets = { require("mini.snippets").gen_loader.from_lang() } -- loads friendly-snippets automatically
        })
        require("mini.snippets").start_lsp_server({ match = false })
        local hipatterns = require('mini.hipatterns')
        hipatterns.setup({
            highlighters = {
                -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })

        vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { fg = "#000000", bg = "#325CC0", bold = true })

        local MiniFiles = require("mini.files")
        vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
        vim.keymap.set("n", "<leader>-", function()
            MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
            MiniFiles.reveal_cwd()
        end, { desc = "Toggle into currently opened file's directory" })
        vim.keymap.set("n", "<leader>pf", function() require("mini.pick").builtin.files() end, { desc = "File picking" })
        vim.keymap.set("n", "<leader>ps",
            function() require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
            { desc = "Pick file with search word pattern" })
        vim.keymap.set("n", "<leader>vh", function() require("mini.pick").builtin.help() end, { desc = "Mini help" })
        vim.keymap.set("n", "<leader>xx", function() require("mini.extra").pickers.diagnostic() end,
            { desc = "Search diagnostics" })
        vim.keymap.set("n", "<leader>pk", function() require("mini.extra").pickers.keymaps() end,
            { desc = "Search keymaps" })
    end,
}
