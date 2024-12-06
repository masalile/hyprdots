-- TABS --

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")
vim.cmd("set relativenumber")

-- KEYBINDINGS --

vim.keymap.set('n', "<C-w>", ":w<CR>")
vim.keymap.set('n', "<C-q>", ":q<CR>")
vim.keymap.set('n', "<C-a>", ":qa<CR>") 
vim.keymap.set('n', "<C-m>", ":qa!<CR>")
vim.keymap.set('n', "<C-e>", ":NvimTreeToggle<CR>")
vim.keymap.set('n', "<C-t>", ":tabnew<CR>")
vim.keymap.set('n', "<C-l>", ":Lazy<CR>")

-- LAZY --
require("config.lazy")
