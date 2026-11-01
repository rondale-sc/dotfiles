-- friendly-snippets registers its test/async/promise snippets (it, desc, aa,
-- apa, tf, …) for javascript only. Load them in TypeScript buffers too.
return {
  {
    "garymjr/nvim-snippets",
    opts = {
      extended_filetypes = {
        typescript = { "javascript" },
        typescriptreact = { "javascript" },
      },
    },
  },
}
