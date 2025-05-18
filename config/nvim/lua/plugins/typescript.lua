return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          typescript = {
            tsdk = "./.yarn/sdks/typescript/lib",
          },
        },
      },
    },
  },
}
