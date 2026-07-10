return {
    { -- Main LSP configuration
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
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

            -- default
            vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { desc = "Go to Implementation" })   -- Go to Implementation
            vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, { desc = "Go to Type Definition" }) -- Go to Type Definition
            vim.keymap.set('n', 'grr', function()
                vim.lsp.buf.references({                                                                -- Fetch usage references across the active project structure workspace
                    includeDeclaration = true,
                    on_list = function(options)
                        vim.fn.setqflist({}, ' ', options) -- Dumps the references array directly into the system quickfix stack
                        vim.cmd('copen')                   -- Open the quickfix window UI layout without pulling your active focus away
                    end
                })
            end, { desc = "LSP References to Quickfix List" })
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Action" })
            vim.keymap.set('n', 'grx', vim.lsp.codelens.run, { desc = "LSP: Run CodeLens Command" })
            vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol, { desc = "LSP: List Document Symbols" })
            vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = "LSP: Show Signature Help" })

            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
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
        config = function()
            require("hover").setup({
                providers = {
                    'hover.providers.diagnostic',
                    'hover.providers.lsp',
                    'hover.providers.dap',
                    'hover.providers.man',
                    'hover.providers.dictionary',
                    -- Optional, disabled by default:
                    -- 'hover.providers.gh',
                    -- 'hover.providers.gh_user',
                    -- 'hover.providers.jira',
                    -- 'hover.providers.fold_preview',
                    -- 'hover.providers.highlight',
                },
            })
            vim.keymap.set('n', 'K', function() require('hover').open() end, { desc = 'hover.nvim (open)' })
            vim.keymap.set('n', 'gK', function() require('hover').enter() end, { desc = 'hover.nvim (enter)' })
            vim.keymap.set('n', '<C-p>', function() require('hover').switch('previous') end,
                { desc = 'hover.nvim (previous source)' })
            vim.keymap.set('n', '<C-n>', function() require('hover').switch('next') end,
                { desc = 'hover.nvim (next source)' })

            -- Mouse support
            vim.o.mousemoveevent = true
            vim.keymap.set('n', '<MouseMove>', function() require('hover').mouse() end, { desc = 'hover.nvim (mouse)' })
        end,
    }
}
