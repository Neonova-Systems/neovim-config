return {
    "Cassin01/wf.nvim",
    version = "*",
    lazy = false,
    keys = {
        { "<Leader>", function() require("wf.builtin.which_key")({ text_insert_in_advance = "<Leader>" })() end, desc = "[wf.nvim] which-key" },
    },
    config = function()
        require("wf").setup({})
    end,
}
