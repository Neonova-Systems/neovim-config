-- Harpoon submenu built on harpoon2 (configured in lua/plugins/harpoon.lua).

local harpoon = require "harpoon"

-- Harpoon stores entries as root-relative paths, so an item for the current
-- file has to be normalized the same way (harpoon/config.lua normalize_path).
local function current_item()
    return harpoon:list().config:create_list_item()
end

return {
    {
        name = "Add File",
        cmd = function() harpoon:list():add() end,
        rtxt = "<leader>a",
    },

    {
        name = "Remove File",
        cmd = function() harpoon:list():remove(current_item()) end,
    },

    {
        name = "Toggle Quick Menu",
        cmd = function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        rtxt = "<C-e>",
    },

    { name = " separator" },

    {
        name = "Slot 1",
        cmd = function() harpoon:list():select(1) end,
        rtxt = "<C-h>",
    },

    {
        name = "Slot 2",
        cmd = function() harpoon:list():select(2) end,
        rtxt = "<C-j>",
    },

    {
        name = "Slot 3",
        cmd = function() harpoon:list():select(3) end,
        rtxt = "<C-k>",
    },

    {
        name = "Slot 4",
        cmd = function() harpoon:list():select(4) end,
        rtxt = "<C-l>",
    },

    { name = " separator" },

    {
        name = "Next File",
        cmd = function() harpoon:list():next() end,
    },

    {
        name = "Prev File",
        cmd = function() harpoon:list():prev() end,
    },
}
