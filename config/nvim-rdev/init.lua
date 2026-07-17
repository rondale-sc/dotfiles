vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.updatetime = 300
opt.signcolumn = "yes"

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>write<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>quit<cr>", { noremap = true, silent = true })
