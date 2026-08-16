return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.mapping["<tab>"] = function(fallback)
        return LazyVim.cmp.confirm({ select = true })(function()
          return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
        end)
      end
    end,
  },
}
