-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

vim.opt.relativenumber = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- <C-l/h> to switch tabs
vim.keymap.set("n", "<C-h>", ":tabprevious<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":tabnext<CR>", { silent = true })

-- Simulate Buffer Explorer buffer list
vim.keymap.set("n", "<leader>be", ":Telescope buffers<CR>")

vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
