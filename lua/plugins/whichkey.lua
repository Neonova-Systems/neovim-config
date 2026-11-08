    "Cassin01/wf.nvim",
    version = "*",
    config = function()
        require("wf").setup({
            theme = "default",
        })
        local which_key = require("wf.builtin.which_key")
        vim.keymap.set(
          "n",
          "<Leader>",
          which_key({ text_insert_in_advance = "<Leader>" }),
          { noremap = true, silent = true, desc = "[wf.nvim] which-key", nowait = true }
        )
    end,
}