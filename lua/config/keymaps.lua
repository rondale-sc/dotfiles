-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- <C-l/h> to switch tabs
vim.keymap.set("n", "<C-h>", ":tabprevious<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":tabnext<CR>", { silent = true })

-- Simulate Buffer Explorer buffer list
vim.keymap.set("n", "<leader>be", ":Telescope buffers<CR>")
