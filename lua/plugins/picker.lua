return {
    'mini.nvim/mini.pick',
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
        -- Map C-j to execute move_down action during active picker
        vim.keymap.set('i', '<C-j>', function()
            minipick.default_choose() -- or invoke minipick built-in actions
        end)

        -- Map C-j to trigger C-p inside mini.pick buffer
        vim.api.nvim_create_autocmd('User', {
            pattern = 'MiniPickStart',
            callback = function(args)
                vim.keymap.set('i', '<C-j>', '<C-p>', { buffer = args.data.buf_id, remap = true })
            end,
        })
    end,
    keys = {
        { "<leader>ps", function() require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, desc = "Pick file with search word pattern" },
        { '<leader>ff', function() require('mini.pick').builtin.files() end,                                      desc = 'Find Files' },
        { '<leader>fg', function() require('mini.pick').builtin.grep_live() end,                                  desc = 'Grep Live' },
        { '<leader>fb', function() require('mini.pick').builtin.buffers() end,                                    desc = 'Find Buffers' },
        { '<leader>fh', function() require('mini.pick').builtin.help() end,                                       desc = 'Find Help' },
    },
}
