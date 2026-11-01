-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.s" },
  command = ":set ft=asm_ca65",
})

-- On save in TS files, apply the fixes TypeScript can make without asking:
-- add missing imports, then "fix all" (the safe subset; same as <leader>cM /
-- <leader>cD). Anything else is a quick fix: <leader>ca on the diagnostic.
local function apply_ts_source_action(client, bufnr, kind)
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.range = { start = { line = 0, character = 0 }, ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 } }
  params.context = { diagnostics = {}, only = { kind } }
  local response = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
  for _, action in ipairs((response and response.result) or {}) do
    if not action.edit and action.data then
      local resolved = client:request_sync("codeAction/resolve", action, 1000, bufnr)
      action = (resolved and resolved.result) or action
    end
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.mts", "*.cts" },
  callback = function(args)
    local client = vim.lsp.get_clients({ bufnr = args.buf, name = "vtsls" })[1]
    if not client then
      return
    end
    apply_ts_source_action(client, args.buf, "source.addMissingImports.ts")
    apply_ts_source_action(client, args.buf, "source.fixAll.ts")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})
