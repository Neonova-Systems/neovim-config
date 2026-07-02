return {
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

        require("mason").setup()
        require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers), })
        for server_name, config in pairs(servers) do
            require("lspconfig")[server_name].setup(config)
        end
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())
        vim.lsp.config("*", { capabilities = capabilities, })

        -- default
        -- vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, opts)  -- Go to Implementation
        -- vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, opts)  -- Go to Type Definition
        -- vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts)       -- Find References
        -- vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)           -- Rename
        -- vim.keymap.set({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, opts) -- Code Action
        -- vim.keymap.set('n', 'grx', vim.lsp.codelens.run, opts)         -- Run CodeLens
        -- vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol, opts)   -- Document Symbols
        -- vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts) -- Signature help
        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show documentation" }))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
        vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, { desc = "Lists all symbols in the current workspace in the quickfix window." })
    end,
}
