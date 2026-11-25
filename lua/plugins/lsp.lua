return {
	{ -- Main LSP configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/trouble.nvim",
		},
		lazy = false,
		config = function()
			require("trouble").setup({
				warn_no_results = false, -- don't notify when the auto-opened panel finds nothing
			})

			-- Patch trouble's treesitter decoration provider: this Neovim
			-- version's vim.treesitter.highlighter lacks _on_win/_on_line,
			-- which causes "attempt to call a nil value" on every redraw.
			local tt = require("trouble.view.treesitter")
			tt.setup = function() end -- no-op: skip decoration provider registration

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
					},
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
				},
			}

			require("mason").setup({
				ui = {
					icons = {
						package_pending = "", -- The list icon to use for packages that are pending installation.
						package_installed = "", -- The list icon to use for installed packages.
						package_uninstalled = "", -- The list icon to use for packages that are not installed.
					},
				},
			})
			require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
			end
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
			vim.lsp.config("*", { capabilities = capabilities })

			-- Glance peek-first goto workflow: gd/grr/gri/grt open side panels;
			-- g<Space>d / g<Space>r jump directly (the old behavior).
			vim.keymap.set("n", "gd", "<cmd>Glance definitions<CR>", { desc = "Glance: Peek Definitions" })
			vim.keymap.set("n", "gD", "<cmd>Glance declarations<CR>", { desc = "Glance: Peek Declarations" })
			vim.keymap.set("n", "grr", "<cmd>Glance references<CR>", { desc = "Glance: Peek References" })
			vim.keymap.set("n", "gri", "<cmd>Glance implementations<CR>", { desc = "Glance: Peek Implementations" })
			vim.keymap.set("n", "grt", "<cmd>Glance type_definitions<CR>", { desc = "Glance: Peek Type Definitions" })

			-- Direct-jump fallbacks (the old nvim-lsp behavior, one extra key)
			-- vim.keymap.set('n', 'g<Space>d', vim.lsp.buf.definition, { desc = "LSP: Jump to Definition" })
			-- vim.keymap.set('n', 'g<Space>D', vim.lsp.buf.declaration, { desc = "LSP: Jump to Declaration" })
			-- vim.keymap.set('n', 'g<Space>i', vim.lsp.buf.implementation, { desc = "LSP: Jump to Implementation" })
			-- vim.keymap.set('n', 'g<Space>t', vim.lsp.buf.type_definition, { desc = "LSP: Jump to Type Definition" })
			-- vim.keymap.set('n', 'g<Space>r', function()
			--     local lsp_params = { context = { includeDeclaration = true } }
			--     local local_options = {
			--         on_list = function(options)
			--             vim.fn.setqflist({}, ' ', options)
			--             vim.cmd('copen')
			--         end
			--     }
			--     vim.lsp.buf.references(lsp_params, local_options)
			-- end, { desc = "LSP: Jump to References (quickfix)" })

			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
			vim.keymap.set("n", "grx", vim.lsp.codelens.run, { desc = "LSP: Run CodeLens Command" })
			vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, { desc = "LSP: List Document Symbols" })
			vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "LSP: Show Signature Help" })
			vim.keymap.set("n", "gsh", vim.lsp.buf.signature_help, { desc = "LSP: Show Signature Help" })
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
			vim.keymap.set(
				"n",
				"<leader>vws",
				vim.lsp.buf.workspace_symbol,
				{ desc = "Lists all symbols in the current workspace in the quickfix window." }
			)

			-- Open Trouble panels after LSP attaches — diagnostics on the bottom
			-- split, LSP navigation modes (defs/refs/impls/types/decls/symbols)
			-- on the right sidebar. Fires after a short defer so the LSP has
			-- populated the diagnostic list before Trouble renders.
			local function open_trouble_diagnostics()
				local diags = vim.diagnostic.get(0)
				if #diags == 0 then
					return
				end
				local ok, trouble = pcall(require, "trouble")
				if ok then
					trouble.open({ mode = "diagnostics", focus = false, win = { type = "split", position = "bottom" } })
				end
			end

			local function open_trouble_lsp()
				local ok, trouble = pcall(require, "trouble")
				if not ok then
					return
				end
				trouble.open({ mode = "lsp_definitions", focus = false, win = { type = "split", position = "right" } })
				trouble.open({ mode = "lsp_references", focus = false, win = { type = "split", position = "right" } })
				trouble.open({
					mode = "lsp_implementations",
					focus = false,
					win = { type = "split", position = "right" },
				})
				trouble.open({
					mode = "lsp_type_definitions",
					focus = false,
					win = { type = "split", position = "right" },
				})
				trouble.open({ mode = "lsp_declarations", focus = false, win = { type = "split", position = "right" } })
				trouble.open({
					mode = "lsp_document_symbols",
					focus = false,
					win = { type = "split", position = "right" },
				})
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					vim.defer_fn(function()
						open_trouble_diagnostics()
						open_trouble_lsp()
					end, 200)
				end,
			})

			vim.api.nvim_create_autocmd("DiagnosticChanged", {
				callback = function()
					vim.defer_fn(open_trouble_diagnostics, 100)
				end,
			})
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
			-- grn is the standard nvim-lsp rename keymap; reuse it for inc-rename
			-- so the live-preview rename workflow is reachable without a new binding.
			vim.keymap.set("n", "grn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true, desc = "LSP Rename (live preview)" })
		end,
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			require("actions-preview").setup({
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
			})
		end,
	},
	{
		"lewis6991/hover.nvim",
		keys = {
			{
				"K",
				function()
					require("hover").open()
				end,
				desc = "hover.nvim (open)",
			},
			{
				"gK",
				function()
					require("hover").enter()
				end,
				desc = "hover.nvim (enter)",
			},
			{
				"<C-n>",
				function()
					require("hover").switch("next")
				end,
				desc = "hover.nvim (next source)",
			},
		},
		config = function()
			require("hover").config({
				providers = {
					"hover.providers.diagnostic",
					"hover.providers.lsp",
					"hover.providers.dap",
					"hover.providers.man",
					"hover.providers.dictionary",
					-- Optional, disabled by default:
					"hover.providers.gh",
					"hover.providers.gh_user",
					"hover.providers.jira",
					"hover.providers.fold_preview",
					"hover.providers.highlight",
				},
				preview_opts = {
					border = "single",
				},
				-- Whether the contents of a currently open hover window should be moved
				-- to a :h preview-window when pressing the hover keymap.
				preview_window = false,
				title = true,
			})
		end,
	},
}
