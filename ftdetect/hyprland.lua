vim.api.nvim_create_autocmd({"BufRead","BufNewfile"}, {pattern = "hyprland.conf", command = "setfiletype hyprlang"}) -- Create autocommand that will detecting matching pattern and execute command
