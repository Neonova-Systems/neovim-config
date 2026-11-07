-- Picker submenu. Uses mini.pick (preferred) with telescope fallback.

local function mini_pick(name)
    return function() require("mini.pick").builtin[name]() end
end

return {
    {
        name = "Find Files",
        cmd = mini_pick("files"),
        rtxt = "<leader>ff",
    },

    {
        name = "Recent Files",
        cmd = mini_pick("oldfiles"),
        rtxt = "<leader>fr",
    },

    {
        name = "Buffers",
        cmd = mini_pick("buffers"),
        rtxt = "<leader>fb",
    },

    {
        name = "Help Tags",
        cmd = mini_pick("help"),
        rtxt = "<leader>fh",
    },

    { name = " separator" },

    {
        name = "Grep (Live)",
        cmd = mini_pick("grep_live"),
        rtxt = "<leader>fg",
    },

    {
        name = "Grep Word",
        cmd = mini_pick("grep"),
        rtxt = "<leader>fw",
    },

    { name = " separator" },

    {
        name = "LSP References",
        cmd = function() require("mini.extra").pickers.lsp({ scope = "references" }) end,
        rtxt = "gr",
    },

    {
        name = "LSP Definitions",
        cmd = function() require("mini.extra").pickers.lsp({ scope = "definition" }) end,
        rtxt = "gd",
    },

    {
        name = "LSP Implementations",
        cmd = function() require("mini.extra").pickers.lsp({ scope = "implementation" }) end,
        rtxt = "gi",
    },

    {
        name = "LSP Type Defs",
        cmd = function() require("mini.extra").pickers.lsp({ scope = "type_definition" }) end,
        rtxt = "gt",
    },

    { name = " separator" },

    {
        name = "Commands",
        cmd = mini_pick("commands"),
        rtxt = "<leader>fc",
    },

    {
        name = "Keymaps",
        cmd = mini_pick("keymaps"),
        rtxt = "<leader>fk",
    },

    {
        name = "Registers",
        cmd = mini_pick("registers"),
        rtxt = "<leader>fR",
    },

    {
        name = "Colorschemes",
        cmd = mini_pick("colorschemes"),
        rtxt = "<leader>fC",
    },

    { name = " separator" },

    {
        name = "Telescope Find Files",
        cmd = ":Telescope find_files",
        rtxt = "tf",
    },

    {
        name = "Telescope Live Grep",
        cmd = ":Telescope live_grep",
        rtxt = "tg",
    },

    {
        name = "Telescope Buffers",
        cmd = ":Telescope buffers",
        rtxt = "tb",
    },
}