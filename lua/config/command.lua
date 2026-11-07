local command = vim.api.nvim_create_user_command -- Declare variable that will be used to creating global user-commands

command("TSPrintNode", function() vim.notify(require("nvim-treesitter.ts_utils").get_node_at_cursor():type()) end,
    { nargs = 0, desc = 'Get treesitter-node name on current cursor' })
command("Menu", function(opts) require("../lua/menu").open(opts.args ~= "" and opts.args or "default") end,
    { nargs = "?", desc = 'Open the floating context menu (optionally a menus/ module name, e.g. :Menu lsp)' })
