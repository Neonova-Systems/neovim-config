return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "tree-sitter-cli",
                "lua-language-server",
                "prettier",
                "prettierd",
                "selene",
                "shellcheck",
                "shfmt",
                "stylua",
                "eslint-lsp",
                "oxlint",
                "oxfmt",
                "tailwindcss-language-server",
                "vtsls",
                "rust-analyzer",
            },
            auto_update = false,
            run_on_start = true,
        })
    end,
}