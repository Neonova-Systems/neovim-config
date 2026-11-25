return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
        local gs = require("gitsigns")

        -- gitsigns no longer accepts a `keymaps` config field: unknown fields are
        -- warned about and ignored, so maps are set from `on_attach` instead.
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
        end

        -- Visual mode needs an explicit range: stage_hunk()/reset_hunk() only act
        -- on the selection when one is passed.
        local function visual_range()
            return { vim.fn.line("."), vim.fn.line("v") }
        end

        gs.setup({
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▏" },
            },
            current_line_blame_opts = { delay = 500 },
            on_attach = function()
                -- Hunk navigation
                map("n", "]c", function() gs.nav_hunk("next") end, "Next hunk")
                map("n", "[c", function() gs.nav_hunk("prev") end, "Previous hunk")

                -- Stage / reset, normal and visual (visual = stage selected lines)
                map("n", "gh", gs.stage_hunk, "Stage hunk")
                map("n", "gH", gs.reset_hunk, "Reset hunk")
                map("v", "gh", function() gs.stage_hunk(visual_range()) end, "Stage selection")
                map("v", "gH", function() gs.reset_hunk(visual_range()) end, "Reset selection")

                -- Buffer-wide
                map("n", "<leader>hs", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>hr", gs.reset_buffer, "Reset buffer")

                -- Inspection
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>hb", function() gs.toggle_current_line_blame() end, "Toggle line blame")
                map("n", "<leader>hd", gs.diffthis, "Diff this")
            end,
        })
    end,
}