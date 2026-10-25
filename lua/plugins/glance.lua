return {
    "DNLHC/glance.nvim",
    cmd = "Glance",
    keys = {
        { "gpd", "<cmd>Glance definitions<CR>", desc = "Glance: Peek Definitions" },
        { "gpr", "<cmd>Glance references<CR>", desc = "Glance: Peek References" },
        { "gpi", "<cmd>Glance implementations<CR>", desc = "Glance: Peek Implementations" },
        { "gpy", "<cmd>Glance type_definitions<CR>", desc = "Glance: Peek Type Definitions" },
    },
    opts = {
        height = 18,
        border = {
            enable = true,
            top_char = "―",
            bottom_char = "―",
        },
        theme = {
            mode = "auto",
        },
    },
}
