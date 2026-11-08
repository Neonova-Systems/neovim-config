return {
    "nvim-mini/mini.nvim",
    version = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    keys = {
        { "-", function() require("mini.files").open() end, desc = "Toggle mini file explorer" },
        { "<leader>-", function()
            local MiniFiles = require("mini.files")
            MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
            MiniFiles.reveal_cwd()
        end, desc = "Toggle into current file's directory" },
    },
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
            },
            content = function()
                local MiniFiles = require("mini.files")
                local fs = vim.fs
                local cwd = vim.fn.getcwd()
                local entries = {}
                local function scan(dir, depth)
                    local handle = vim.uv.fs_scandir(dir)
                    if not handle then return end
                    local items = {}
                    while true do
                        local name, type = vim.uv.fs_scandir_next(handle, name)
                        if not name then break end
                        if name ~= "." and name ~= ".." then
                            table.insert(items, { name = name, type = type, path = dir .. "/" .. name })
                        end
                    end
                    table.sort(items, function(a, b)
                        if a.type ~= b.type then return a.type == "directory" end
                        return a.name < b.name
                    end)
                    for _, item in ipairs(items) do
                        local prefix = string.rep("  ", depth)
                        local icon, hl
                        if item.type == "directory" then
                            icon, hl = "", "MiniFilesDirectory"
                        else
                            local ext = item.name:match("%.([^.]+)$")
                            if ext == "lua" then icon, hl = "", "MiniFilesLua"
                            elseif ext == "js" or ext == "ts" or ext == "jsx" or ext == "tsx" then icon, hl = "", "MiniFilesJs"
                            elseif ext == "py" then icon, hl = "", "MiniFilesPy"
                            elseif ext == "go" then icon, hl = "", "MiniFilesGo"
                            elseif ext == "rs" then icon, hl = "", "MiniFilesRs"
                            elseif ext == "c" or ext == "h" or ext == "cpp" or ext == "hpp" then icon, hl = "", "MiniFilesC"
                            elseif ext == "json" or ext == "yaml" or ext == "yml" or ext == "toml" then icon, hl = "", "MiniFilesConfig"
                            elseif ext == "md" or ext == "txt" then icon, hl = "", "MiniFilesText"
                            elseif ext == "git" or item.name == ".git" then icon, hl = "", "MiniFilesGit"
                            else icon, hl = "", "MiniFilesFile"
                        end
                        table.insert(entries, { prefix = prefix, icon = icon, name = item.name, hl = hl, path = item.path, type = item.type })
                        if item.type == "directory" and depth < 2 then
                            scan(item.path, depth + 1)
                        end
                    end
                end
                scan(cwd, 0)
                local lines = {}
                for _, e in ipairs(entries) do
                    table.insert(lines, e.prefix .. e.icon .. " " .. e.name)
                end
                return lines
            end,
        })
        local MiniNotify = require("mini.notify")
        MiniNotify.setup({
            content = {
                format = function(notif) return notif.msg end, -- only show messages
            }
        })

        -- Errors and warnings stay on screen until dismissed instead of vanishing
        -- after a few seconds, which makes them impossible to read while debugging.
        -- duration <= 0 is treated by mini.notify as "never show", so a large
        -- finite value is used to approximate persistent.
        vim.notify = MiniNotify.make_notify({
            ERROR = { duration = 60000, hl_group = "DiagnosticError" },
            WARN  = { duration = 60000, hl_group = "DiagnosticWarn" },
            INFO  = { duration = 5000, hl_group = "DiagnosticInfo" },
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
        vim.keymap.set('i', '<Tab>', function()
            return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
        end, { expr = true })

        vim.keymap.set('i', '<S-Tab>', function()
            return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
        end, { expr = true })
        require("mini.snippets").setup({
            snippets = { require("mini.snippets").gen_loader.from_lang() }, -- loads friendly-snippets automatically
            mappings = {
                expand = '<C-j>',
                jump_next = '<C-l>',
                jump_prev = '<C-h>', -- Change or remove if overriding <C-h>
            },
        })

        -- Map Insert Mode <C-BS> / <C-h> to delete word without snippet collision
        vim.keymap.set('i', '<C-BS>', '<C-w>')
        vim.keymap.set('i', '<C-h>', function()
            -- Fallback to <C-w> if not active in snippet
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>', true, true, true), 'n', true)
        end)
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

        vim.keymap.set("n", "<leader>fd", function() require("mini.extra").pickers.diagnostic({ scope = "current" }) end,
            { desc = "Search diagnostics (current buffer)" })
        vim.keymap.set("n", "<leader>fD", function() require("mini.extra").pickers.diagnostic({ scope = "all" }) end,
            { desc = "Search diagnostics (workspace)" })
    end,
}
