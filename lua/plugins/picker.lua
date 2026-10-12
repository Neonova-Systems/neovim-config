return {
    "nvim-mini/mini.pick",
    dependencies = { "nvim-mini/mini.nvim", },
    version = false, -- use main branch for latest updates
    config = function()
        local minipick = require('mini.pick')
        local win_config = function()
            local height = math.floor(0.618 * vim.o.lines)
            local width = math.floor(0.618 * vim.o.columns)
            return {
                anchor = 'NW',
                height = height,
                width = width,
                row = math.floor(0.5 * (vim.o.lines - height)),
                col = math.floor(0.5 * (vim.o.columns - width)),
            }
        end

        minipick.setup({
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

                -- move_down         = '<C-j>',
                move_down         = '<C-n>',

                move_start        = '<C-g>',
                -- move_up         = '<C-k>',
                move_up           = '<C-p>',

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
            { window = { config = win_config } }
        })
    end,
    keys = {
        { "<leader>fs", function() require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, desc = "Pick file with search word pattern" },
        { '<leader>ff', function() require('mini.pick').builtin.files() end,                                      desc = 'Find Files' },
        { '<leader>fg', function() require('mini.pick').builtin.grep_live() end,                                  desc = 'Grep Live' },
        { '<leader>fb', function() require('mini.pick').builtin.buffers() end,                                    desc = 'Find Buffers' },
        { '<leader>fh', function() require('mini.pick').builtin.help() end,                                       desc = 'Find Help' },
        {
            '<leader>fw',
            function()
                local current_word = vim.fn.expand('<cword>')
                if current_word == "" then return end

                -- Find the workspace root by looking for common project markers (.git folder or Makefile)
                local root_files = { '.git', 'Makefile', 'package.json' }
                local workspace_root = vim.fs.root(0, root_files) or vim.fn.getcwd()

                -- Launch picker targeted directly at the workspace root directory path
                require('mini.pick').builtin.grep({
                    pattern = current_word,
                    source = {
                        cwd = workspace_root -- Explicitly overrides the search execution boundary path
                    }
                })
            end,
            desc = "Fuzzy Pick word at workspace Root"
        },
    },
}
