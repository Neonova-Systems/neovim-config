-- Picker submenu for mini.pick / mini.extra (lua/plugins/picker.lua,
-- lua/plugins/mini.lua). Deferred so each picker opens after the menu float
-- closes and focus is back in the source window.

local function deferred(fn)
    return function() vim.schedule(fn) end
end

local pick = require("mini.pick").builtin
local extra = require("mini.extra").pickers

return {
    {
        name = "Find Files",
        cmd = deferred(function() pick.files() end),
        rtxt = "<leader>ff",
    },

    {
        name = "Grep Live",
        cmd = deferred(function() pick.grep_live() end),
        rtxt = "<leader>fg",
    },

    {
        name = "Grep Word Under Cursor",
        cmd = deferred(function()
            pick.grep { pattern = vim.fn.expand "<cword>" }
        end),
        rtxt = "<leader>fs",
    },

    {
        name = "Find Buffers",
        cmd = deferred(function() pick.buffers() end),
        rtxt = "<leader>fb",
    },

    { name = " separator" },

    {
        name = "Git Files",
        cmd = deferred(function() extra.git_files() end),
    },

    {
        name = "Git Branches",
        cmd = deferred(function() extra.git_branches() end),
    },

    {
        name = "Old Files",
        cmd = deferred(function() extra.oldfiles() end),
    },

    {
        name = "Marks",
        cmd = deferred(function() extra.marks() end),
    },

    {
        name = "Registers",
        cmd = deferred(function() extra.registers() end),
    },

    {
        name = "Jumps and Visits",
        cmd = deferred(function() extra.visit_paths() end),
    },

    {
        name = "Treesitter Nodes",
        cmd = deferred(function() extra.treesitter() end),
    },

    { name = " separator" },

    {
        name = "Keymaps",
        cmd = deferred(function() extra.keymaps() end),
        rtxt = "<leader>pk",
    },

    {
        name = "Options",
        cmd = deferred(function() extra.options() end),
    },

    {
        name = "Commands",
        cmd = deferred(function() extra.commands() end),
    },

    {
        name = "Highlight Groups",
        cmd = deferred(function() extra.hl_groups() end),
    },

    {
        name = "Help Pages",
        cmd = deferred(function() pick.help() end),
        rtxt = "<leader>fh",
    },
}
