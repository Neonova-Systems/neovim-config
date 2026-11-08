return {
    { -- Main LSP configuration
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        lazy = false,
        config = function()
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { checkThirdParty = false },
                        },
                    },
                },
                bashls = {
                    filetypes = {
                        "sh",
                        "bash",
                        "zsh",
                        "csh",
                    }
                },
                pyright = {},
                rust_analyzer = {
                    ["rust-analyzer"] = {
                        cargo = { allTargets = false },
                        procMacro = { enable = true },
                    },
                },
                clangd = {},
                ts_ls = {
                    init_options = {
                        preferences = {
                            -- Enable auto-imports layouts
                            includeCompletionsForModuleExports = true,
                            -- Auto-insert code hints for parameter types
                            includeInlayParameterNameHints = "all", -- Options: "none", "literals", "all"
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    settings = {
                        javascript = {
                            format = { indentSize = 2, tabSize = 2 },
                        },
                        typescript = {
                            format = { indentSize = 2, tabSize = 2 },
                        },
                    },
                }
            }

            require("mason").setup({
                ui = {
                    icons = {
                        package_pending = "", -- The list icon to use for packages that are pending installation.
                        package_installed = "", -- The list icon to use for installed packages.
                        package_uninstalled = "", -- The list icon to use for packages that are not installed.
                    },
                }
            })
            require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers), })
            for server_name, config in pairs(servers) do
                vim.lsp.config(server_name, config)
            end
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())
            vim.lsp.config("*", { capabilities = capabilities, })

            -- Glance peek-first goto workflow: gd/grr/gri/grt open side panels;
            -- g<Space>d / g<Space>r jump directly (the old behavior).
            vim.keymap.set('n', 'gd', "<cmd>Glance definitions<CR>", { desc = "Glance: Peek Definitions" })
            vim.keymap.set('n', 'gD', "<cmd>Glance declarations<CR>", { desc = "Glance: Peek Declarations" })
            vim.keymap.set('n', 'grr', "<cmd>Glance references<CR>", { desc = "Glance: Peek References" })
            vim.keymap.set('n', 'gri', "<cmd>Glance implementations<CR>", { desc = "Glance: Peek Implementations" })
            vim.keymap.set('n', 'grt', "<cmd>Glance type_definitions<CR>", { desc = "Glance: Peek Type Definitions" })

            -- Direct-jump fallbacks (the old nvim-lsp behavior, one extra key)
            vim.keymap.set('n', 'g<Space>d', vim.lsp.buf.definition, { desc = "LSP: Jump to Definition" })
            vim.keymap.set('n', 'g<Space>D', vim.lsp.buf.declaration, { desc = "LSP: Jump to Declaration" })
            vim.keymap.set('n', 'g<Space>i', vim.lsp.buf.implementation, { desc = "LSP: Jump to Implementation" })
            vim.keymap.set('n', 'g<Space>t', vim.lsp.buf.type_definition, { desc = "LSP: Jump to Type Definition" })
            vim.keymap.set('n', 'g<Space>r', function()
                local lsp_params = { context = { includeDeclaration = true } }
                local local_options = {
                    on_list = function(options)
                        vim.fn.setqflist({}, ' ', options)
                        vim.cmd('copen')
                    end
                }
                vim.lsp.buf.references(lsp_params, local_options)
            end, { desc = "LSP: Jump to References (quickfix)" })

            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Action" })
            vim.keymap.set('n', 'grx', vim.lsp.codelens.run, { desc = "LSP: Run CodeLens Command" })
            vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol, { desc = "LSP: List Document Symbols" })
            vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = "LSP: Show Signature Help" })
            vim.keymap.set('n', 'gsh', vim.lsp.buf.signature_help, { desc = "LSP: Show Signature Help" })
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
            vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol,
                { desc = "Lists all symbols in the current workspace in the quickfix window." })
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
            vim.keymap.set("n", "<leader>grn", function() return ":IncRename " .. vim.fn.expand("<cword>") end,
                { expr = true, desc = "LSP Rename" })
        end,
    },
    {
        "aznhe21/actions-preview.nvim",
        config = function()
            require("actions-preview").setup {
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.8,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 15
                        end,
                    },
                },
            }
        end,
    },
    {
        "lewis6991/hover.nvim",
        keys = {
            { "K", function() require('hover').open() end, desc = 'hover.nvim (open)' },
            { "gK", function() require('hover').enter() end, desc = 'hover.nvim (enter)' },
            { "<C-p>", function() require('hover').switch('previous') end, desc = 'hover.nvim (previous source)' },
            { "<C-n>", function() require('hover').switch('next') end, desc = 'hover.nvim (next source)' },
        },
        config = function()
            require("hover").config({
                providers = {
                    'hover.providers.diagnostic',
                    'hover.providers.lsp',
                    'hover.providers.dap',
                    'hover.providers.man',
                    'hover.providers.dictionary',
                    -- Optional, disabled by default:
                    'hover.providers.gh',
                    'hover.providers.gh_user',
                    'hover.providers.jira',
                    'hover.providers.fold_preview',
                    'hover.providers.highlight',
                },
              preview_opts = {
                border = 'single'
              },
              -- Whether the contents of a currently open hover window should be moved
              -- to a :h preview-window when pressing the hover keymap.
              preview_window = false,
              title = true,
            })
        end,
    }
}
