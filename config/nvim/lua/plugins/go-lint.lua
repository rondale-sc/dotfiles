-- golangci-lint v2 (Mason) requires `version: "2"` in .golangci.yml.
-- Projects with v1-format configs cause a parse error on every file open.
-- Override args via opts so the replacement is applied inside nvim-lint's
-- own config function, before any linting runs.
return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters.golangcilint = {
        args = {
          "run",
          "--no-config",
          "--output.json.path=stdout",
          "--output.text.path=",
          "--output.tab.path=",
          "--output.html.path=",
          "--output.checkstyle.path=",
          "--output.code-climate.path=",
          "--output.junit-xml.path=",
          "--output.teamcity.path=",
          "--output.sarif.path=",
          "--issues-exit-code=0",
          "--show-stats=false",
          "--path-mode=abs",
          function()
            local buf = vim.api.nvim_buf_get_name(0)
            local mod = vim.fn.system({ "go", "env", "GOMOD" }):gsub("%s+", "")
            local modifier = (mod == "" or mod == "/dev/null") and ":p" or ":h"
            return vim.fn.fnamemodify(buf, modifier)
          end,
        },
      }
    end,
  },
}
