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

        local function harpoon_available()
            return pcall(require, "harpoon")
        end

        local function mini_pick(name)
            return function() require("mini.pick").builtin[name]() end
        end

        local function picker_lsp(scope)
            return function() require("mini.extra").pickers.lsp({ scope = scope }) end
        end

        local function picker_diagnostic(scope)
            return function() require("mini.extra").pickers.diagnostic({ scope = scope }) end
        end

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
            { name = " separator" },
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
            { name = " separator" },
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
                rtxt = "gpt",
            },
            {
                name = "Peek Implementations",
                cmd = "Glance implementations",
                rtxt = "gpi",
            },
            { name = " separator" },
            {
                name = "Document Symbols",
                cmd = picker_lsp("document_symbol"),
                rtxt = "gO",
            },
            {
                name = "Workspace Symbols",
                cmd = picker_lsp("workspace_symbol"),
                rtxt = "gW",
            },
            {
                name = "Show Signature Help",
                cmd = vim.lsp.buf.signature_help,
                rtxt = "gh",
            },
            {
                name = "Restart LSP",
                cmd = ":LspRestart",
                rtxt = "lr",
            },
            { name = " separator" },
            {
                name = "Stage Hunk",
                cmd = function() require("gitsigns").stage_hunk() end,
                rtxt = "ghs",
            },
            {
                name = "Unstage Hunk",
                cmd = function() require("gitsigns").undo_stage_hunk() end,
                rtxt = "ghu",
            },
            {
                name = "Reset Hunk",
                cmd = function() require("gitsigns").reset_hunk() end,
                rtxt = "ghr",
            },
            { name = " separator" },
            {
                name = "Preview Hunk",
                cmd = function() require("gitsigns").preview_hunk() end,
                rtxt = "ghp",
            },
            {
                name = "Blame Line",
                cmd = function() require("gitsigns").blame_line({ full = true }) end,
                rtxt = "ghb",
            },
            { name = " separator" },
            {
                name = "Diff This",
                cmd = function() require("gitsigns").diffthis() end,
                rtxt = "ghd",
            },
            {
                name = "Diff This ~",
                cmd = function() require("gitsigns").diffthis("~") end,
                rtxt = "ghD",
            },
            { name = " separator" },
            {
                name = "Git Status",
                cmd = ":Git status",
                rtxt = "gs",
            },
            {
                name = "Git Commit",
                cmd = ":Git commit",
                rtxt = "gc",
            },
            {
                name = "Git Push",
                cmd = ":Git push",
                rtxt = "gp",
            },
            {
                name = "Git Pull",
                cmd = ":Git pull",
                rtxt = "gP",
            },
            {
                name = "Git Log",
                cmd = ":Git log --oneline -20",
                rtxt = "gl",
            },
            { name = " separator" },
            {
                name = "Add File",
                cmd = function() if harpoon_available() then require("harpoon"):list():add() end end,
                rtxt = "ha",
            },
            {
                name = "Quick Menu",
                cmd = function() if harpoon_available() then require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end end,
                rtxt = "hm",
            },
            { name = " separator" },
            {
                name = "File 1",
                cmd = function() if harpoon_available() then require("harpoon"):list():select(1) end end,
                rtxt = "h1",
            },
            {
                name = "File 2",
                cmd = function() if harpoon_available() then require("harpoon"):list():select(2) end end,
                rtxt = "h2",
            },
            {
                name = "File 3",
                cmd = function() if harpoon_available() then require("harpoon"):list():select(3) end end,
                rtxt = "h3",
            },
            {
                name = "File 4",
                cmd = function() if harpoon_available() then require("harpoon"):list():select(4) end end,
                rtxt = "h4",
            },
            { name = " separator" },
            {
                name = "Next File",
                cmd = function() if harpoon_available() then require("harpoon"):list():next() end end,
                rtxt = "hn",
            },
            {
                name = "Prev File",
                cmd = function() if harpoon_available() then require("harpoon"):list():prev() end end,
                rtxt = "hp",
            },
            {
                name = "Clear All",
                cmd = function() if harpoon_available() then require("harpoon"):list():clear() end end,
                rtxt = "hC",
            },
            { name = " separator" },
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
                cmd = picker_lsp("references"),
                rtxt = "gr",
            },
            {
                name = "LSP Definitions",
                cmd = picker_lsp("definition"),
                rtxt = "gd",
            },
            {
                name = "LSP Implementations",
                cmd = picker_lsp("implementation"),
                rtxt = "gi",
            },
            {
                name = "LSP Type Defs",
                cmd = picker_lsp("type_definition"),
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
            { name = " separator" },
            {
                name = "Document Diagnostics",
                cmd = picker_diagnostic("current"),
                rtxt = "dd",
            },
            {
                name = "Workspace Diagnostics",
                cmd = picker_diagnostic("all"),
                rtxt = "dD",
            },
            { name = " separator" },
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
            { name = " separator" },
            {
                name = "Open Float",
                cmd = vim.diagnostic.open_float,
                rtxt = "gk",
            },
            {
                name = "Set Loclist",
                cmd = vim.diagnostic.setloclist,
                rtxt = "dl",
            },
            {
                name = "Set Qflist",
                cmd = vim.diagnostic.setqflist,
                rtxt = "dq",
            },
            { name = " separator" },
            {
                name = "Toggle Virtual Text",
                cmd = function()
                    local cfg = vim.diagnostic.config()
                    local vt = cfg and cfg.virtual_text
                    vim.diagnostic.config({ virtual_text = not vt })
                    vim.notify("Virtual text: " .. (not vt and "on" or "off"))
                end,
                rtxt = "dt",
            },
            {
                name = "Toggle Underline",
                cmd = function()
                    local cfg = vim.diagnostic.config()
                    local ul = cfg and cfg.underline
                    vim.diagnostic.config({ underline = not ul })
                    vim.notify("Underline: " .. (not ul and "on" or "off"))
                end,
                rtxt = "du",
            },
        }

        package.preload["menus.default"] = function() return menu_items end

        vim.api.nvim_create_user_command("Menu", function(opts)
            require("menu").open(opts.args ~= "" and opts.args or "default")
        end, { nargs = "?", desc = "Open the floating context menu" })

        require("menu.utils").delete_old_menus()
    end,
}