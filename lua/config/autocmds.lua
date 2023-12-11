-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

local function updatePluginLockFile()
  -- Check if lazy-lock.json has changes
  local hasChanges = os.execute("git diff --exit-code --quiet lazy-lock.json")

  -- If there are changes (hasChanges is false), then add and commit
  if hasChanges ~= 0 then
    -- Get current date and time
    local dateTime = os.date("%Y-%m-%d %H:%M:%S")

    -- Run Git commands to add and commit changes
    os.execute("git add lazy-lock.json")
    os.execute('git commit -m "Update plugins ' .. dateTime .. '"')
  end
end

-- Create autocommands for LazyInstall and LazyUpdate events
vim.api.nvim_create_autocmd("User", {
  pattern = { "LazyInstall", "LazyUpdate" },
  callback = updatePluginLockFile,
})
