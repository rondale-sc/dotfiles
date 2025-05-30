return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "codecompanion" },
      },
    },
    opts = {
      strategies = {
        opts = {
          log_level = "DEBUG", -- or "TRACE"
        },
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              description = "Reject the suggested change",
            },
          },
        },
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "models/gemini-2.0-flash-lite",
              },
            },
            env = {
              api_key = "cmd:op read op item get 'GeminiAPIKey' --fields credential --reveal",
            },
          })
        end,
      },
    },
  },
}
