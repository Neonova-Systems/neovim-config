-- Shared action helpers, used by keybindings.lua, plugin configs, and the context menu
local M = {}

function M.lsp_references_qf()
    local params = { context = { includeDeclaration = true } }
    vim.lsp.buf.references(params, {
        on_list = function(options)
            vim.fn.setqflist({}, " ", options)
            vim.cmd("copen")
        end,
    })
end

function M.grep_word_at_root()
    local word = vim.fn.expand("<cword>")
    if word == "" then return end
    local root = vim.fs.root(0, { ".git", "Makefile", "package.json" }) or vim.fn.getcwd()
    require("telescope.builtin").live_grep({ default_text = word, cwd = root })
end

--- Spawn lazygit in a floating toggleterm window.
-- Uses a dedicated terminal object so lazygit stays independent of the
-- generic toggle (it isn't affected by <c-\> or :ToggleTerm).
function M.lazygit()
    local Terminal = require("toggleterm.terminal").Terminal
    local git = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
            border = "single",
            winblend = 0,
            width = function()
                return math.floor(vim.o.columns * 0.9)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.9)
            end,
        },
        on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>",
                { noremap = true, silent = true })
        end,
        close_on_exit = true,
    })
    git:toggle()
end

return M
