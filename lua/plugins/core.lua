return {
  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end,
  },
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },
  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- git configuration
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-rsi" },
  { "tpope/vim-eunuch" },
  { "mustache/vim-mustache-handlebars" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          -- Default configuration for telescope goes here:
          -- config_key = value,
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            },
          },
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    config = function()
      local bufferline = require("bufferline")

      bufferline.setup({
        options = {
          mode = "tabs", -- set to "tabs" to only show tabpages instead
        },
      })
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
