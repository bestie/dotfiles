M = {}

M.mv_file = function()
  local current_path = vim.fn.expand("%:.")
  local new_path = ""

  local ok, new_path = pcall(function()
    -- Prompt for new file name with file name completion
    return vim.fn.input("New file name: ", current_path, "file")
  end)

  if not ok or string.len(new_path) < 1 then
    vim.notify("Rename aborted", vim.log.levels.ERROR)
    return
  end


  -- exec command :saveas
  local success, err = pcall(vim.cmd, "saveas " .. new_path)
  if not success then
    vim.notify("Error new saving file: " .. err, vim.log.levels.ERROR)
    return
  end

  -- exec command :delete
  success, err = pcall(vim.cmd, "silent! !rm " .. current_path)
  if not success then
    vim.notify("Error old file: " .. err, vim.log.levels.ERROR)
    return
  end

  -- remove the buffer
  vim.cmd("bdelete " .. current_path)
  vim.cmd("file " .. new_path)

  vim.notify("File moved to " .. new_path, vim.log.levels.INFO)
end

return M
