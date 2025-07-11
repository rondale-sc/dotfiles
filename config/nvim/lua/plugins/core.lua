return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  { "ellisonleao/gruvbox.nvim" },
  { "navarasu/onedark.nvim" },
  { "folke/tokyonight.nvim" },
  { "nvim-lua/plenary.nvim" },
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
  { import = "lazyvim.plugins.extras.lang.python" },

  -- git configuration
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-rsi" },
  { "tpope/vim-eunuch" },
  -- { "AndrewRadev/ember_tools.vim" },
  { "mustache/vim-mustache-handlebars" },
  -- { "mxsdev/nvim-dap-vscode-js" },
  { "microsoft/vscode-js-debug" },
  { "mfussenegger/nvim-dap" },
  { "jay-babu/mason-nvim-dap.nvim" },

  {
    "rcarriga/nvim-notify",
    opts = {
      level = 3,
      stages = "fade",
      timeout = 3000,
      top_down = false,
    },
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
}
