-- SSH known_hosts filetype detection
-- Migrated from ftdetect/sshknownhosts.lua (vimscript) to lua.

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "known_hosts",
    callback = function()
        vim.bo.filetype = "sshknownhosts"
    end,
})

-- Register the lua syntax file so it loads when filetype=sshknownhosts is set.
-- Neovim ≥ 0.10 resolves syntax/<filetype>.lua from the runtime path; this
-- explicit registration makes the migration work regardless of version.
vim.filetype.add({
    source = {
        sshknownhosts = function()
            require("syntax.sshknownhosts")
        end,
    },
})