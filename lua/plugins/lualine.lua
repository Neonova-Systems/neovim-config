-- Lualine helpers, inlined so this config does not depend on an upstream module layout.

local M = {}

local root_patterns = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

local function get_cwd()
    return vim.uv.cwd() or vim.fn.getcwd()
end

local function normalize(path)
    if path:sub(1, 1) == "~" then
        path = vim.fn.expand(path)
    end
    path = vim.uv.fs_realpath(path) or path
    return path:gsub("/$", "")
end

local function get_root()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        path = get_cwd()
    end
    path = vim.fs.dirname(path)

    local root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
    if root then
        return normalize(vim.fs.dirname(root))
    end

    return normalize(get_cwd())
end

local function color_of(name)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if not hl.fg then
        return nil
    end
    -- lualine's color parser accepts "#rrggbb" strings but rejects 24-bit
    -- integers, so format the highlight fg as hex rather than passing the raw int.
    return { fg = string.format("#%06x", hl.fg) }
end

--- Condensed path showing first segment, an ellipsis, then the tail.
local function pretty_path(opts)
    opts = vim.tbl_extend("force", {
        relative = "cwd",
        modified_hl = "MatchParen",
        directory_hl = "",
        filename_hl = "Bold",
        modified_sign = "",
        readonly_icon = " 󰌾 ",
        length = 3,
    }, opts or {})

    return function(self)
        local path = vim.fn.expand("%:p")

        if path == "" then
            return ""
        end

        path = normalize(path)

        local cwd = normalize(get_cwd())
        local root = opts.relative == "root" and get_root() or cwd

        local path_lower = path:lower()
        local root_lower = root:lower()
        if vim.fn.has("win32") == 1 then
            if path_lower:find(root_lower, 1, true) == 1 then
                path = path:sub(#root + 2)
            end
        else
            if path:find(root, 1, true) == 1 then
                path = path:sub(#root + 2)
            end
        end

        local sep = package.config:sub(1, 1)
        local parts = vim.split(path, "[\\/]")

        if opts.length > 0 and #parts > opts.length then
            local truncated = { parts[1], "…" }
            for i = #parts - opts.length + 2, #parts do
                table.insert(truncated, parts[i])
            end
            parts = truncated
        end

        local filename = parts[#parts]
        local dir = ""
        if #parts > 1 then
            dir = table.concat(vim.list_slice(parts, 1, #parts - 1), sep) .. sep
        end

        local hl_group = "lualine_c_normal"
        if self and self.options and self.options.section then
            hl_group = "lualine_" .. self.options.section .. "_normal"
        end

        local dir_hl = opts.directory_hl ~= "" and opts.directory_hl or nil
        local dir_part = dir_hl and ("%#" .. dir_hl .. "#" .. dir .. "%#" .. hl_group .. "#") or dir

        local modified = vim.bo.modified
        local readonly = vim.bo.readonly or not vim.bo.modifiable

        local file_hl = modified and opts.modified_hl or opts.filename_hl
        local file_part = file_hl and file_hl ~= "" and ("%#" .. file_hl .. "#" .. filename .. "%#" .. hl_group .. "#")
            or filename

        local result = dir_part .. file_part

        if modified and opts.modified_sign ~= "" then
            result = result .. opts.modified_sign
        end

        if readonly then
            result = result .. opts.readonly_icon
        end

        return result
    end
end

--- Project root name, hidden when it is redundant with the cwd.
local function root_dir(opts)
    opts = vim.tbl_extend("force", {
        cwd = false,
        subdirectory = true,
        parent = true,
        other = true,
        icon = "󱉭 ",
        color = function()
            local c = color_of("Special")
            return c or {}
        end,
    }, opts or {})

    local function get()
        local cwd = normalize(get_cwd())
        local root = get_root()
        local name = vim.fs.basename(root)

        if root == cwd then
            return opts.cwd and name
        elseif root:find(cwd, 1, true) == 1 then
            return opts.subdirectory and name
        elseif cwd:find(root, 1, true) == 1 then
            return opts.parent and name
        else
            return opts.other and name
        end
    end

    return {
        function()
            return (opts.icon and opts.icon .. " ") .. get()
        end,
        cond = function()
            return type(get()) == "string"
        end,
        color = opts.color,
    }
end

--- Register currently being recorded into; pair with RecordingEnter/Leave.
local function macro_recording(opts)
    opts = vim.tbl_extend("force", {
        icon = "󰑋 ",
        color = function()
            local c = color_of("DiagnosticError")
            return c and { fg = c.fg, gui = "bold" } or { gui = "bold" }
        end,
    }, opts or {})

    return {
        function()
            return opts.icon .. vim.fn.reg_recording()
        end,
        cond = function()
            return vim.fn.reg_recording() ~= ""
        end,
        color = opts.color,
    }
end

M.pretty_path = pretty_path
M.root_dir = root_dir
M.macro_recording = macro_recording

return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
        local icons = {
            diagnostics = { Error = " ", Warn = " ", Hint = " ", Info = " " },
            git = { added = " ", modified = " ", removed = " " },
        }

        require("lualine").setup({
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
                refresh = {
                    events = {
                        "WinEnter",
                        "BufEnter",
                        "BufWritePost",
                        "SessionLoadPost",
                        "FileChangedShellPost",
                        "VimResized",
                        "Filetype",
                        "CursorMoved",
                        "CursorMovedI",
                        "ModeChanged",
                        -- Macro
                        "RecordingEnter",
                        "RecordingLeave",
                    },
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },

                lualine_c = {
                    root_dir(),
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    {
                        pretty_path({
                            length = 0,
                            relative = "cwd",
                            modified_hl = "MatchParen",
                            directory_hl = "",
                            filename_hl = "Bold",
                            modified_sign = "",
                            readonly_icon = " 󰌾 ",
                        }),
                    },
                },
                lualine_x = {
                    macro_recording(),
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.Error,
                            warn = icons.diagnostics.Warn,
                            info = icons.diagnostics.Info,
                            hint = icons.diagnostics.Hint,
                        },
                    },
                    {
                        "diff",
                        symbols = {
                            added = icons.git.added,
                            modified = icons.git.modified,
                            removed = icons.git.removed,
                        },
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed,
                                }
                            end
                        end,
                    },
                },
                lualine_y = {
                    { "progress", separator = " ", padding = { left = 1, right = 1 } },
                },
                lualine_z = {
                    { "location", padding = { left = 1, right = 1 } },
                },
            },
        })
    end,
}