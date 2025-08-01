return {
  "tpope/vim-fugitive",
  event = "VeryLazy",
  config = function()
    local augroup = require("core.utils").augroup

    augroup("FugitiveUser", {
      -- add custom bindings for Git Blame buffer
      {
        event = { "FileType" },
        pattern = { "fugitiveblame" },
        command = function()
          vim.keymap.set("n", "q", ":q<CR>", { noremap = true, buffer = true, desc = "Close Blame" })
          vim.keymap.set("n", "<leader>gb", ":q<CR>", { noremap = true, buffer = true, desc = "Close Blame" })
        end,
      },
    })
  end,
}
