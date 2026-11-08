-- SSH known_hosts syntax highlighting
-- Loaded via ftdetect/sshknownhosts.lua which sets filetype=sshknownhosts

vim.opt_local.iskeyword = "@,48-57,_,192-255,#,-"

vim.cmd([[ syntax match sshknownhostspubkey "AAA[0-9a-zA-Z+/]\+[=]\{0,2}" ]])
vim.cmd([[ highlight link sshknownhostspubkey Special ]])
vim.cmd([[ syntax keyword sshalg ssh-rsa ]])
vim.cmd([[ highlight link sshalg Identifier ]])
vim.cmd([[ syntax match sshknownhostsip "\<\(\d\{1,3}\.\)\{3}\d\{1,3}\>" ]])
vim.cmd([[ hi link sshknownhostsip Constant ]])

