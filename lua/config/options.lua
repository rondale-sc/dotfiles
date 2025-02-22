-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

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

-- Ensure :vsplit will open the new pane to the right
vim.opt.splitright = true

-- Ensure :split will open the new pane below current pane
vim.opt.splitbelow = true

-- Use visual bel instead of beeping
vim.opt.visualbell = true

vim.g.foldexpr = "v:lnum==1?'>1':getline(v:lnum)=~'import'?1:nvim_treesitter#foldexpr()"

-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"
