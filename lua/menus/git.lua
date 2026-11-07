-- Git submenu driven by mini.diff / mini.git (configured in lua/plugins/git.lua),
-- replacing the upstream gitsigns menu which targeted an uninstalled plugin.

-- Act on the hunk under the cursor; the cursor lives in the caller window by
-- the time the menu runs an item, so the current window position is correct.
local function hunk_action(action)
    return function()
        local ok, err = pcall(function()
            local buf = vim.api.nvim_get_current_buf()
            local line = vim.api.nvim_win_get_cursor(0)[1]
            require("mini.diff").do_hunks(buf, action, { line_start = line, line_end = line })
        end)
        if not ok then
            vim.notify("mini.diff: " .. tostring(err), vim.log.levels.WARN)
        end
    end
end

local function goto_hunk(direction)
    return function()
        local ok, err = pcall(require("mini.diff").goto_hunk, direction)
        if not ok then
            vim.notify("mini.diff: " .. tostring(err), vim.log.levels.WARN)
        end
    end
end

-- Defer until the menu float is closed: these open their own windows/pickers.
local function deferred(fn)
    return function() vim.schedule(fn) end
end

return {
    {
        name = "Stage Hunk (index)",
        cmd = hunk_action("apply"),
        rtxt = "gh",
    },

    {
        name = "Reset Hunk",
        cmd = hunk_action("reset"),
        rtxt = "gH",
    },

    {
        name = "Next Hunk",
        cmd = goto_hunk("next"),
        rtxt = "]h",
    },

    {
        name = "Prev Hunk",
        cmd = goto_hunk("prev"),
        rtxt = "[h",
    },

    {
        name = "Toggle Diff Overlay",
        cmd = function() require("mini.diff").toggle_overlay(0) end,
        rtxt = "<leader>go",
    },

    { name = " separator" },

    {
        name = "Pick Hunks",
        cmd = deferred(function() require("mini.extra").pickers.git_hunks() end),
    },

    {
        name = "Pick Git Files",
        cmd = deferred(function() require("mini.extra").pickers.git_files() end),
    },

    {
        name = "Git Commits",
        cmd = deferred(function() require("mini.extra").pickers.git_commits() end),
    },

    { name = " separator" },

    {
        name = "Line Range History",
        cmd = deferred(function() require("mini.git").show_range_history() end),
        rtxt = "<leader>gh",
    },

    {
        name = "Git Data at Cursor",
        cmd = deferred(function() require("mini.git").show_at_cursor() end),
        rtxt = "<leader>gc",
    },
}
