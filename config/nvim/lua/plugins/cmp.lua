return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- cmp normalizes keys, so LazyVim's "<tab>" is stored as "<Tab>".
      -- Override that exact key, or two Tab handlers race and LazyVim's wins.
      opts.mapping["<tab>"] = nil
      opts.mapping["<Tab>"] = function(fallback)
        return LazyVim.cmp.confirm({ select = true })(function()
          return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
        end)
      end
    end,
  },
}
