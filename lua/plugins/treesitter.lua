return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    init = function()
        local ensure_installed = { 
            -- Programming languages
            "c", "lua",  "javascript", "typescript", "tsx", "python", "rust", "go", "java", "kotlin", "php", "ruby", "c_sharp", "cpp",

            -- Markup languages
            "html", "css", 

            -- Extras
            "http", "markdown", "regex", "markdown_inline", "bash", "dockerfile", "gitignore", "yaml", "toml", "json", "vimdoc",
        }
        local installed = require("nvim-treesitter.config").get_installed()
        local missing = vim.iter(ensure_installed):filter(function(p)
            return not vim.tbl_contains(installed, p)
        end):totable()

        if #missing > 0 then
            require("nvim-treesitter").install(missing)
        end
    end,
    config = function()
        require("nvim-treesitter").setup()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                local buf = args.buf
                local ft = vim.bo[buf].filetype

                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then
                    return
                end

                local ok_add = pcall(vim.treesitter.language.add, lang)
                if not ok_add then
                    return
                end

                pcall(vim.treesitter.start, buf, lang)
            end,
        })
    end,
}
