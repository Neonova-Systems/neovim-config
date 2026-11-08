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
    require("mini.pick").builtin.grep({ pattern = word, source = { cwd = root } })
end

return M
