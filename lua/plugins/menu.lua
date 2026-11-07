return {
    "nvzone/menu",
    dependencies = { "nvzone/volt" },
    keys = {
        { "<C-t>", function() require("menu").open("default") end, desc = "Open context menu" },
        { "<RightMouse>", function()
            require("menu.utils").delete_old_menus()
            require("menu").open("default", { mouse = true })
        end, desc = "Open context menu (mouse)" },
    },
    cmd = "Menu",
    config = function()
        vim.api.nvim_create_user_command("Menu", function(opts)
            require("menu").open(opts.args ~= "" and opts.args or "default")
        end, { nargs = "?", desc = "Open the floating context menu" })

        require("menu.utils").delete_old_menus()
    end,
}