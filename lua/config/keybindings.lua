-- Remap
vim.g.mapleader = " " -- Set Space as <leader> key
-- vim.keymap.set('n', ';', ':', {noremap = true})
vim.keymap.set('', '<Up>', '<Nop>', {noremap = true})
vim.keymap.set('', '<Down>', '<Nop>', {noremap = true})
vim.keymap.set('', '<Left>', '<Nop>', {noremap = true})
vim.keymap.set('', '<Right>', '<Nop>', {noremap = true})
vim.keymap.set("x", "p", [[_dP]], { desc = "Paste over selection without overwriting the default register" })
vim.keymap.set({"n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole register" })
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', '<C-c>', ':noh<CR>', {noremap = true, silent = true, desc = 'Clean up searching'})

-- Quick fix list navigation
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', {noremap = true, silent = true, desc = 'Display the previous error in the list that includes a file name.'})
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', {noremap = true, silent = true, desc = 'Display the next error in the list that includes a file name.'})

-- Moving lines of text up and down
vim.keymap.set({"v", "x"}, 'J', ":move '>+1<CR>gv=gv", {noremap = true, silent = true, desc = 'Moving text down 1 line visual-mode & select-mode'})
vim.keymap.set({"v", "x"}, 'K', ":move '<-2<CR>gv=gv", {noremap = true, silent = true, desc = 'Moving text up 1 line visual-mode & select-mode'})
vim.keymap.set('n', '<leader>j', ':move .+1<CR>==', {noremap = true, silent = true, desc = 'Moving text down 1 line normal-mode'})
vim.keymap.set('n', '<leader>k', ':move .-2<CR>==', {noremap = true, silent = true, desc = 'Moving text up 1 line normal-mode'})

vim.keymap.set("v", "<", "<gv", {desc = 'Unindenting text and keep selection'})
vim.keymap.set("v", ">", ">gv", {desc = 'Indenting text and keep selection'})
vim.keymap.set('n', 'J', 'mzJ`z', {noremap = true, desc = 'Join lines without moving cursor'})
vim.keymap.set('n', '<C-d>', '<C-d>zz', {desc = 'move down in buffer with cursor centered'})
vim.keymap.set('n', '<C-u>', '<C-u>zz', {desc = 'move up in buffer with cursor centered'})
vim.keymap.set('n', 'n', "nzzzv", {noremap = true, desc='Centering cursor when search'})
vim.keymap.set('n', 'N', "Nzzzv", {noremap = true, desc='Centering cursor when search backward'})
vim.keymap.set('n', "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI>Left><Left><Left>]], {desc = "Replace all occurrences of the word under the cursor"})
vim.keymap.set('n', "<leader>x", "<cmd>!chmod +x %<CR>", {desc = "Make file executable"})
vim.keymap.set('n', "<leader>re", "<cmd>restart<cr>", {desc = "Restart Neovim (:restart)"})
vim.keymap.set('n', 'Y', "y$", {noremap = true, desc = 'Yanking to end of the line'})
vim.keymap.set('n', '<leader>w', function() vim.cmd("up") end, {noremap = true, silent = true, desc = 'Save File'})
vim.keymap.set('n', '<C-q>', ':qall<CR>', {noremap = true, desc = 'Force Quit'})
vim.keymap.set('n', '<leader><leader>a', ':%y+<CR>', {noremap = true, silent = true, desc = 'Copy this file'})
vim.keymap.set('n', '<leader>o', ':call append(line("."), repeat([""], v:count1))<CR>', {noremap = true, silent = true, desc = 'Add newline without enter insert-mode'})
vim.keymap.set('i', '<C-f>', '<Esc>gUiw`]a', {noremap = true, desc = 'Uppercase word undercursor'})
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, {desc = 'Toggle Builtin Undotree'})

-- Undo break-point
vim.keymap.set('i', ',', ',<c-g>u', {noremap = true, desc = 'Set undo break-point'})
vim.keymap.set('i', '.', '.<c-g>u', {noremap = true, desc = 'Set undo break-point'})
vim.keymap.set('i', '!', '!<c-g>u', {noremap = true, desc = 'Set undo break-point'})
vim.keymap.set('i', '?', '?<c-g>u', {noremap = true, desc = 'Set undo break-point'})
vim.keymap.set('i', '#', '#<c-g>u', {noremap = true, desc = 'Set undo break-point'})

-- Moving arround panes
vim.keymap.set('n', '<Left>', '<C-w>h', {noremap = true, silent = true, desc = 'Move to left pane'})
vim.keymap.set('n', '<Down>', '<C-w>j', {noremap = true, silent = true, desc = 'Move to down pane'})
vim.keymap.set('n', '<Up>', '<C-w>k', {noremap = true, silent = true, desc = 'Move to up pane'})
vim.keymap.set('n', '<Right>', '<C-w>l', {noremap = true, silent = true, desc = 'Move to right pane'})
vim.keymap.set('n', 'sh', '<C-w>h', {noremap = true, silent = true, desc = 'Move to left pane'})
vim.keymap.set('n', 'sj', '<C-w>j', {noremap = true, silent = true, desc = 'Move to down pane'})
vim.keymap.set('n', 'sk', '<C-w>k', {noremap = true, silent = true, desc = 'Move to up pane'})
vim.keymap.set('n', 'sl', '<C-w>l', {noremap = true, silent = true, desc = 'Move to right pane'})

-- Command-line mode keymaps
vim.keymap.set("c", "<C-h>", "<BS>")
vim.keymap.set("c", "<C-w>", "<C-u><C-w>")
vim.keymap.set("c", "<C-u>", "<C-u><C-u>")
vim.keymap.set("c", "<C-BS>", "<C-w>", { remap = false }) -- Delete word backward using Ctrl + Backspace