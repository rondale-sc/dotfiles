-- refactoring.nvim added lewis6991/async.nvim as a dependency but the
-- LazyVim extra omits it. The telescope extension was also dropped from
-- newer versions, so override config to skip load_extension and remap
-- <leader>rs to use the native select_refactor() picker.
return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
      vim.keymap.set({ "n", "x" }, "<leader>rs", function()
        require("refactoring").select_refactor()
      end, { desc = "Select Refactor" })
    end,
  },
}
