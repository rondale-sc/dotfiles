-- Vitest adapter for neotest (LazyVim's test.core extra only ships the
-- runner; Go has its own adapter via the lang.go extra).
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "marilari88/neotest-vitest" },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
      },
    },
  },
}
