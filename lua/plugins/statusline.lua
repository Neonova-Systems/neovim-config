return {
    "nvim-mini/mini.nvim",
    config = function()
        local statusline = require("mini.statusline")

        local function get_lsp_status()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, client in pairs(clients) do
                table.insert(names, client.name)
            end
            return " 󰄭 " .. table.concat(names, " 󰄭 ")
        end

        local function get_diagnostic_status()
            local counts = {
                E = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
                W = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
                I = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
                H = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
            }
            local parts = {}
            if counts.E > 0 then table.insert(parts, "" .. counts.E) end
            if counts.W > 0 then table.insert(parts, "" .. counts.W) end
            if counts.I > 0 then table.insert(parts, "" .. counts.I) end
            if counts.H > 0 then table.insert(parts, "" .. counts.H) end
            return #parts > 0 and (" " .. table.concat(parts, " ") .. " ") or ""
        end

        local function get_mode_name()
            local current_mode = vim.api.nvim_get_mode().mode
            local mode_map = {
                ['n']   = 'NORMAL',
                ['v']   = 'VISUAL',
                ['V']   = 'V-LINE',
                ['\22'] = 'V-BLOCK',
                ['i']   = 'INSERT',
                ['R']   = 'REPLACE',
                ['c']   = 'COMMAND',
                ['t']   = 'TERMINAL',
            }
            return mode_map[current_mode] or current_mode
        end

        local function get_macro()
            local recording = vim.fn.reg_recording()
            return (recording ~= "" and vim.o.cmdheight == 0) and "  Recording " .. recording .. " " or ""
        end

        local function get_treesitter_context()
            local ok, ts = pcall(vim.treesitter.get_parser, 0)
            if not ok or not ts then return "" end
            local node = vim.treesitter.get_node({ bufnr = 0 })
            if not node then return "" end
            local lang = ts:lang()
            local parent = node
            while parent do
                local type = parent:type()
                if type == "function_definition" or type == "function_declaration"
                    or type == "method_definition" or type == "class_definition"
                    or type == "struct_item" or type == "impl_item"
                    or type == "function_item" or type == "function_call" then
                    local text = vim.treesitter.get_node_text(parent, 0)
                    if text and text[1] then
                        return "  " .. lang .. " " .. text[1]:sub(1, 40)
                    end
                end
                parent = parent:parent()
            end
            return ""
        end

        local function get_indent_status()
            local indent = vim.bo.expandtab and ("  " .. vim.bo.shiftwidth .. "sp")
                or ("  " .. vim.bo.tabstop .. "t")
            local spell = vim.wo.spell and "  Spell" or ""
            return indent .. spell
        end

        local function get_file_meta()
            local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or "utf-8"
            local format = vim.bo.fileformat ~= "" and vim.bo.fileformat or "unix"
            local eol = vim.bo.eol and "" or "  [noeol]"
            return " " .. encoding .. " " .. format .. eol
        end

        local function custom_active_content()
            local mode_str = get_mode_name()
            local search = (vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0) and statusline.section_searchcount({}) or ""
            local macro = get_macro()

            -- Paths and Flags
            local filename = vim.fn.expand("%:.")
            if filename == "" then filename = "[No Name]" end
            local modified = vim.bo.modified and "  " or "  "
            local readonly = ((not vim.bo.modifiable) or vim.bo.readonly) and "" or ""

            -- Components
            local lsp = get_lsp_status()
            local diag = get_diagnostic_status()
            local git = statusline.section_git({ trunc_width = 75 })
            local filetype = vim.bo.filetype
            local location = statusline.section_location({ trunc_width = 999 })
            local indent = get_indent_status()
            local ts = get_treesitter_context()
            local meta = get_file_meta()

            -- Layout format assembly
            return string.format(
                "%s%s%s %s%s%s %s%s %s %s %s %s %s %s",
                search, macro, mode_str, filename, modified, readonly, "%=",
                git, diag, lsp, filetype, indent, ts, meta, location
            )
        end

        -- Plugin Initialization
        statusline.setup({
            content = {
                active = custom_active_content,
                inactive = function() return "%F" end,
            },
            use_icons = true,
        })
    end,
}