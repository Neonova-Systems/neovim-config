--  ███╗   ██╗██╗   ██╗██╗███╗   ███╗      ██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗
--  ████╗  ██║██║   ██║██║████╗ ████║      ██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║
--  ██╔██╗ ██║██║   ██║██║██╔████╔██║█████╗██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║
--  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║╚════╝██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║
--  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║      ██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║
--  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝      ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝
local install_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(install_path) then -- If lazy not installed then:
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", install_path }) -- Install lazy into install_path
end
vim.opt.rtp:prepend(install_path) -- Add install_path into runtime path

local config = {
    root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
    defaults = {
        lazy = true, -- should plugins be lazy-loaded?
        -- default `cond` you can use to globally disable a lot of plugins
        -- when running inside vscode for example
        cond = nil, ---@type boolean|fun(self:LazyPlugin):boolean|nil
        version = "*", -- enable this to try installing the latest stable versions of plugins
    },
    spec = nil, ---@type LazySpec leave nil when passing the spec as the first argument to setup()
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
    concurrency = nil, ---@type number limit the maximum amount of concurrent tasks
    git = { 
        log = { "--since=3 days ago" }, -- show commits from the last 3 days, defaults for the `Lazy log` command
        timeout = 120, -- kill processes that take more than 2 minutes
        url_format = "https://github.com/%s.git",
        filter = true,
    },
    dev = { 
        path = "~/projects", -- directory where you store your local plugin projects
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = {}, -- For example {"folke"}
        fallback = true, -- Fallback to git when local plugin doesn't exist
    },
    install = {
        missing = true, -- install missing plugins on startup. This doesn't increase startup time.
        colorscheme = { "habamax" }, -- try to load one of these colorschemes when starting an installation during startup
    },
    ui = {
        size = { width = 0.8, height = 0.8 }, -- a number <1 is a percentage., >1 is a fixed size
        wrap = false, -- wrap the lines in the ui
        border = "none", -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        icons = {
            cmd = " ",
            config = "",
            event = "",
            ft = " ",
            init = " ",
            import = " ",
            keys = " ",
            lazy = "󰒲 ",
            loaded = "●",
            not_loaded = "○",
            plugin = " ",
            runtime = " ",
            source = " ",
            start = "",
            task = "✔ ",
        },
        browser = nil, ---@type string? leave nil, to automatically select a browser depending on your OS. If you want to use a specific browser, you can define it here
        throttle = 20, -- how frequently should the ui process render events
        custom_keys = { -- you can define custom key maps here. To disable one of the defaults, set it to false
            ["<localleader>l"] = function(plugin) -- open lazygit log
                require("lazy.util").float_term({ "lazygit", "log" }, {
                    cwd = plugin.dir,
                })
            end,
            ["<localleader>t"] = function(plugin) -- open a terminal for the plugin dir
                require("lazy.util").float_term(nil, {
                    cwd = plugin.dir,
                })
            end,
        },
    },
    diff = {
        -- diff command <d> can be one of:
        -- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
        --   so you can have a different command for diff <d>
        -- * git: will run git diff and open a buffer with filetype git
        -- * terminal_git: will open a pseudo terminal with git diff
        -- * diffview.nvim: will open Diffview to show the diff
        cmd = "git",
    },
    checker = {
        enabled = true,     -- automatically check for plugin updates
        concurrency = nil,  ---@type number? set to 1 to check for updates very slowly
        notify = true,      -- get a notification when new updates are found
        frequency = 3600,   -- check for updates every hour
    },
    change_detection = {
        enabled = true,     -- automatically check for config file changes and reload the ui
        notify = true,      -- get a notification when changes are found
    },
    performance = {
        cache = { enabled = true, },
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            reset = true,   -- reset the runtime path to $VIMRUNTIME and your config directory
            paths = { "/home/xaxeric/Workspace/neovim-config-worktree" },     -- add any custom paths here that you want to includes in the rtp -@type string[]
            disabled_plugins = { ---@type string[] list any plugins you want to disable here
                -- "netrw",
                -- "netrwPlugin",
                -- "netrwSettings",
                -- "netrwFileHandlers",
                "gzip",
                "zip",
                "zipPlugin",
                "tar",
                "tarPlugin",
                "getscript",
                "getscriptPlugin",
                "vimball",
                "vimballPlugin",
                "2html_plugin",
                "logipat",
                "rrhelper",
                -- "spellfile_plugin",
                -- "matchit"
                -- "matchparen",
                -- "tohtml",
                -- "tutor",
            },
        },
    },
    readme = {
        -- lazy can generate helptags from the headings in markdown readme files, so :help works even for plugins that don't have vim docs.
        -- when the readme opens with :help it will be correctly displayed as markdown
        enabled = true,
        root = vim.fn.stdpath("state") .. "/lazy/readme",
        files = { "README.md", "lua/**/README.md" },
        skip_if_doc_exists = true, -- only generate markdown helptags for plugins that dont have docs
    },
    state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
}

require("lazy").setup("plugins", config)
