if not pcall(require, "ibl") then -- Check if nvim not have indent_blankline plugin
    return -- Stop sourcing this file.
end -- End if-else statement

require("ibl").setup({ -- Call setup function
    indent = { 
        char = "▏", -- Character, or list of characters, that get used to display the indentation guide
        highlight = "Conceal", -- Highlight group, or list of highlight groups, that get applied to the indentation guide
    },
    scope = {
        show_start = true, -- Shows an underline on the first line of the scope
        show_end = false, -- Shows an underline on the last line of the scope
    }
}) 
