-- Harpoon submenu. Uses ThePrimeagen/harpoon (v2 API).

local function harpoon_available()
    return pcall(require, "harpoon")
end

return {
    {
        name = "Add File",
        cmd = function() if harpoon_available() then require("harpoon"):list():add() end end,
        rtxt = "ha",
    },

    {
        name = "Quick Menu",
        cmd = function() if harpoon_available() then require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end end,
        rtxt = "hm",
    },

    { name = " separator" },

    {
        name = "File 1",
        cmd = function() if harpoon_available() then require("harpoon"):list():select(1) end end,
        rtxt = "h1",
    },

    {
        name = "File 2",
        cmd = function() if harpoon_available() then require("harpoon"):list():select(2) end end,
        rtxt = "h2",
    },

    {
        name = "File 3",
        cmd = function() if harpoon_available() then require("harpoon"):list():select(3) end end,
        rtxt = "h3",
    },

    {
        name = "File 4",
        cmd = function() if harpoon_available() then require("harpoon"):list():select(4) end end,
        rtxt = "h4",
    },

    { name = " separator" },

    {
        name = "Next File",
        cmd = function() if harpoon_available() then require("harpoon"):list():next() end end,
        rtxt = "hn",
    },

    {
        name = "Prev File",
        cmd = function() if harpoon_available() then require("harpoon"):list():prev() end end,
        rtxt = "hp",
    },

    { name = " separator" },

    {
        name = "Clear All",
        cmd = function() if harpoon_available() then require("harpoon"):list():clear() end end,
        rtxt = "hC",
    },
}