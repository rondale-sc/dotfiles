return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light" -- or 'light'

      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("live_grep_args")
        require("telescope").load_extension("fzf")
        require("telescope").setup({
          pickers = {
            buffers = {
              mappings = {
                i = {
                  ["<c-a>"] = vim.cmd("!normal! I"),
                },
              },
            },
          },
        })
      end,
    },
  },
}
