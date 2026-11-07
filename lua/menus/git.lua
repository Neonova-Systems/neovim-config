-- Git submenu. Assumes gitsigns.nvim / mini-git / fugitive are available.

return {
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
}