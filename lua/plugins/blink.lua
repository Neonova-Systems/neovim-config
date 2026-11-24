-- stylua: ignore
local kind_icons = {
    Array         = " ",
    Boolean       = "󰨙 ",
    Class         = " ",
    Codeium       = "󰘦 ",
    Color         = " ",
    Control       = " ",
    Collapsed     = " ",
    Constant      = "󰏿 ",
    Constructor   = " ",
    Copilot       = " ",
    Enum          = " ",
    EnumMember    = " ",
    Event         = " ",
    Field         = " ",
    File          = " ",
    Folder        = " ",
    Function      = "󰊕 ",
    Interface     = " ",
    Key           = " ",
    Keyword       = " ",
    Method        = "󰊕 ",
    Module        = " ",
    Namespace     = "󰦮 ",
    Null          = " ",
    Number        = "󰎠 ",
    Object        = " ",
    Operator      = " ",
    Package       = " ",
    Property      = " ",
    Reference     = " ",
    Snippet       = "󱄽 ",
    String        = " ",
    Struct        = "󰆼 ",
    Supermaven    = " ",
    TabNine       = "󰏚 ",
    Text          = " ",
    TypeParameter = " ",
    Unit          = " ",
    Value         = " ",
    Variable      = "󰀫 ",
}

return {
    {
        "saghen/blink.cmp",
        version = "v1.10.2", -- main is v2 and needs saghen/blink.lib
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("blink.cmp").setup({
                snippets = {
                    preset = "default",
                },
                completion = {
                    accept = {
                        -- experimental auto-brackets support
                        auto_brackets = {
                            enabled = true,
                        },
                    },
                    menu = {
                        border = "none",
                        draw = {
                            treesitter = { "lsp" },
                        },
                    },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 200,
                    },
                },
                cmdline = {
                    enabled = true,
                    keymap = {
                        preset = "cmdline",
                        ["<Right>"] = false,
                        ["<Left>"] = false,
                    },
                    completion = {
                        list = { selection = { preselect = false } },
                        menu = {
                            auto_show = function(ctx)
                                return vim.fn.getcmdtype() == ":"
                            end,
                        },
                        ghost_text = { enabled = true },
                    },
                },
                keymap = {
                    preset = "enter",
                    ["c-y"] = { "select_and_accept" },
                },
                appearance = {
                    kind_icons = kind_icons,
                },
            })
        end,
    },
    {
        "nvim-mini/mini.pairs",
        lazy = false,
        config = function()
            require("mini.pairs").setup({
                modes = { insert = true, command = true, terminal = false },
            })
        end,
    },
    -- mini.diff lives in lua/plugins/git.lua (single owner, keeps [c / ]c hunk nav).
}