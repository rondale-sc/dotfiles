return {
  -- friendly-snippets registers its test/async/promise snippets (it, desc, aa,
  -- apa, tf, …) for javascript only. Load them in TypeScript buffers too.
  {
    "garymjr/nvim-snippets",
    opts = {
      extended_filetypes = {
        typescript = { "javascript" },
        typescriptreact = { "javascript" },
      },
    },
  },
  -- In TS/Node buffers the LSP returns hundreds of globals for any 2-letter
  -- prefix, burying snippets (and cmp caps the list at 200). Put a snippet
  -- first only when what you typed is exactly its trigger, so `ca` → the `ca`
  -- snippet but `con` still → const/console.
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local function exact_snippet(entry)
        if entry.source.name ~= "snippets" then
          return false
        end
        local typed = entry.context.cursor_before_line:sub(entry.source_offset)
        return entry:get_completion_item().label == typed
      end
      table.insert(opts.sorting.comparators, 1, function(a, b)
        local a_snip, b_snip = exact_snippet(a), exact_snippet(b)
        if a_snip ~= b_snip then
          return a_snip
        end
      end)
    end,
  },
}
