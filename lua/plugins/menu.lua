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
        local function deferred(fn)
            return function() vim.schedule(fn) end
        end

        local function format_buffer()
            local ok, conform = pcall(require, "conform")
            if ok then conform.format({ lsp_fallback = true }) else vim.lsp.buf.format() end
        end

        local function harpoon()
            local ok, h = pcall(require, "harpoon")
            if ok then return h end
        end

        local function mini_pick(name)
            return function() require("mini.pick").builtin[name]() end
        end

        local function mini_extra(name)
            return function() require("mini.extra").pickers[name]() end
        end

        local function picker_lsp(scope)
            return function() require("mini.extra").pickers.lsp({ scope = scope }) end
        end

        local function picker_diagnostic(scope)
            return function() require("mini.extra").pickers.diagnostic({ scope = scope }) end
        end

        local function lsp_references_qf()
            local params = { context = { includeDeclaration = true } }
            vim.lsp.buf.references(params, {
                on_list = function(options)
                    vim.fn.setqflist({}, " ", options)
                    vim.cmd("copen")
                end,
            })
        end

        local harpoon_submenu = {
            {
                name = "Add File",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():add() end
                end,
                rtxt = "<leader>a",
            },
            {
                name = "Quick Menu",
                cmd = function()
                    local h = harpoon()
                    if h then h.ui:toggle_quick_menu(h:list()) end
                end,
                rtxt = "<C-e>",
            },
            { name = "separator" },
            {
                name = "File 1",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():select(1) end
                end,
                rtxt = "<C-h>",
            },
            {
                name = "File 2",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():select(2) end
                end,
                rtxt = "<C-j>",
            },
            {
                name = "File 3",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():select(3) end
                end,
                rtxt = "<C-k>",
            },
            {
                name = "File 4",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():select(4) end
                end,
                rtxt = "<C-l>",
            },
            { name = "separator" },
            {
                name = "Next File",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():next() end
                end,
            },
            {
                name = "Prev File",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():prev() end
                end,
            },
            {
                name = "Clear All",
                cmd = function()
                    local h = harpoon()
                    if h then h:list():clear() end
                end,
            },
        }

        local menu_items = {
            {
                name = "Format Buffer",
                cmd = format_buffer,
                rtxt = "<leader>f",
            },
            {
                name = "Code Actions",
                cmd = deferred(function() require("actions-preview").code_actions() end),
                rtxt = "<leader>ca",
            },
            {
                name = "Rename Symbol",
                cmd = deferred(function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>grn", true, false, true), "n", false)
                end),
                rtxt = "<leader>grn",
            },
            { name = "separator" },
            {
                name = "Goto Definition",
                cmd = vim.lsp.buf.definition,
                rtxt = "gd",
            },
            {
                name = "Goto Declaration",
                cmd = vim.lsp.buf.declaration,
                rtxt = "gD",
            },
            {
                name = "Goto Implementation",
                cmd = vim.lsp.buf.implementation,
                rtxt = "gri",
            },
            {
                name = "Goto Type Definition",
                cmd = vim.lsp.buf.type_definition,
                rtxt = "grt",
            },
            {
                name = "References",
                cmd = deferred(lsp_references_qf),
                rtxt = "grr",
            },
            { name = "separator" },
            {
                name = "Peek Definitions",
                cmd = "Glance definitions",
                rtxt = "gpd",
            },
            {
                name = "Peek References",
                cmd = "Glance references",
                rtxt = "gpr",
            },
            {
                name = "Peek Type Definitions",
                cmd = "Glance type_definitions",
                rtxt = "gpy",
            },
            {
                name = "Peek Implementations",
                cmd = "Glance implementations",
                rtxt = "gpi",
            },
            { name = "separator" },
            {
                name = "Document Symbols",
                cmd = picker_lsp("document_symbol"),
                rtxt = "gO",
            },
            {
                name = "Workspace Symbols",
                cmd = picker_lsp("workspace_symbol"),
                rtxt = "<leader>vws",
            },
            {
                name = "Show Signature Help",
                cmd = vim.lsp.buf.signature_help,
                rtxt = "<C-s>",
            },
            {
                name = "Hover Documentation",
                cmd = function() require("hover").open() end,
                rtxt = "K",
            },
            {
                name = "Restart LSP",
                cmd = ":LspRestart",
            },
            { name = "separator" },
            {
                name = "Harpoon",
                hl = "ExBlue",
                items = harpoon_submenu,
            },
            { name = "separator" },
            {
                name = "Toggle Diff Overlay",
                cmd = function() require("mini.diff").toggle_overlay(0) end,
                rtxt = "<leader>go",
            },
            {
                name = "Apply Hunks",
                cmd = function() require("mini.diff").do_hunks(0, "apply") end,
                rtxt = "gh",
            },
            {
                name = "Reset Hunks",
                cmd = function() require("mini.diff").do_hunks(0, "reset") end,
                rtxt = "gH",
            },
            {
                name = "Next Hunk",
                cmd = function() require("mini.diff").goto_hunk("next") end,
                rtxt = "]h",
            },
            {
                name = "Prev Hunk",
                cmd = function() require("mini.diff").goto_hunk("prev") end,
                rtxt = "[h",
            },
            { name = "separator" },
            {
                name = "Git Data at Cursor",
                cmd = function() require("mini.git").show_at_cursor() end,
                rtxt = "<leader>gc",
            },
            {
                name = "Git Status",
                cmd = ":Git status",
            },
            {
                name = "Git Commit",
                cmd = ":Git commit",
            },
            {
                name = "Git Push",
                cmd = ":Git push",
            },
            {
                name = "Git Pull",
                cmd = ":Git pull",
            },
            { name = "separator" },
            {
                name = "Find Files",
                cmd = mini_pick("files"),
                rtxt = "<leader>ff",
            },
            {
                name = "Recent Files",
                cmd = mini_extra("oldfiles"),
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
            { name = "separator" },
            {
                name = "Grep (Live)",
                cmd = mini_pick("grep_live"),
                rtxt = "<leader>fg",
            },
            {
                name = "Grep Word",
                cmd = deferred(function() require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") }) end),
                rtxt = "<leader>fs",
            },
            {
                name = "Grep Word (Root)",
                cmd = deferred(function()
                    local word = vim.fn.expand("<cword>")
                    if word == "" then return end
                    local root = vim.fs.root(0, { ".git", "Makefile", "package.json" }) or vim.fn.getcwd()
                    require("mini.pick").builtin.grep({ pattern = word, source = { cwd = root } })
                end),
                rtxt = "<leader>fw",
            },
            { name = "separator" },
            {
                name = "LSP References",
                cmd = picker_lsp("references"),
            },
            {
                name = "LSP Definitions",
                cmd = picker_lsp("definition"),
            },
            {
                name = "LSP Implementations",
                cmd = picker_lsp("implementation"),
            },
            {
                name = "LSP Type Defs",
                cmd = picker_lsp("type_definition"),
            },
            { name = "separator" },
            {
                name = "Commands",
                cmd = mini_extra("commands"),
            },
            {
                name = "Keymaps",
                cmd = mini_extra("keymaps"),
                rtxt = "<leader>pk",
            },
            {
                name = "Registers",
                cmd = mini_extra("registers"),
            },
            {
                name = "Colorschemes",
                cmd = mini_extra("colorschemes"),
            },
            { name = "separator" },
            {
                name = "Document Diagnostics",
                cmd = picker_diagnostic("current"),
            },
            {
                name = "Workspace Diagnostics",
                cmd = picker_diagnostic("all"),
                rtxt = "<leader>xx",
            },
            { name = "separator" },
            {
                name = "Next Diagnostic",
                cmd = function() vim.diagnostic.goto_next({ float = false }) end,
                rtxt = "]d",
            },
            {
                name = "Prev Diagnostic",
                cmd = function() vim.diagnostic.goto_prev({ float = false }) end,
                rtxt = "[d",
            },
            {
                name = "Next Error",
                cmd = function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = false }) end,
                rtxt = "]e",
            },
            {
                name = "Prev Error",
                cmd = function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = false }) end,
                rtxt = "[e",
            },
            { name = "separator" },
            {
                name = "Open Float",
                cmd = vim.diagnostic.open_float,
                rtxt = "]D",
            },
            {
                name = "Set Loclist",
                cmd = vim.diagnostic.setloclist,
            },
            {
                name = "Set Qflist",
                cmd = vim.diagnostic.setqflist,
            },
            { name = "separator" },
            {
                name = "Toggle Virtual Text",
                cmd = function()
                    local cfg = vim.diagnostic.config()
                    local vt = cfg and cfg.virtual_text
                    vim.diagnostic.config({ virtual_text = not vt })
                    vim.notify("Virtual text: " .. (not vt and "on" or "off"))
                end,
            },
            {
                name = "Toggle Underline",
                cmd = function()
                    local cfg = vim.diagnostic.config()
                    local ul = cfg and cfg.underline
                    vim.diagnostic.config({ underline = not ul })
                    vim.notify("Underline: " .. (not ul and "on" or "off"))
                end,
            },
        }

        package.preload["menus.default"] = function() return menu_items end

        vim.api.nvim_create_user_command("Menu", function(opts)
            require("menu").open(opts.args ~= "" and opts.args or "default")
        end, { nargs = "?", desc = "Open the floating context menu" })

        require("menu.utils").delete_old_menus()
    end,
}
