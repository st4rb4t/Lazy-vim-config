vim.g.mapleader = " "
local keymap = vim.keymap

-- Notes / wiki
keymap.set("n", "<leader>n", ":Neorg index<CR>")
keymap.set("n", "<leader>o", ":Obsidian<CR>")

-- Telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")

-- Save
keymap.set("n", "<leader>w", ":w<CR>")

-- File explorer
keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
