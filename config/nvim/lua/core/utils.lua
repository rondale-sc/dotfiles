local M = {}

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T
---@return T
function M.fold(callback, list, accum)
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

--- Validate the keys passed to as.augroup are valid
---@param name string
---@param cmd MyAutocmd
local function validate_autocmd(name, cmd)
  local keys = { "event", "buffer", "pattern", "desc", "command", "group", "once", "nested" }
  local incorrect = M.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, cmd, {})
  if #incorrect == 0 then
    return
  end
  vim.schedule(function()
    vim.notify("Incorrect keys: " .. table.concat(incorrect, ", "), vim.log.levels.ERROR, {
      title = fmt("Autocmd: %s", name),
    })
  end)
end

--- Create an autocommand
--- returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands MyAutocmd[]
---@return number
function M.augroup(name, commands)
  assert(name ~= "User", "The name of an augroup CANNOT be User")

  local id = vim.api.nvim_create_augroup(name, { clear = true })

  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    local callback = is_callback and autocmd.command or nil
    local command = not is_callback and autocmd.command or nil

    vim.api.nvim_create_autocmd(autocmd.event, {
      group = id,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = callback,
      command = command --[[@as string]],
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end

  return id
end

return M
