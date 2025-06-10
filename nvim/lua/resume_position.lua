local M = {}

local excluded_filetypes = {
  "gitcommit",
  "gitrebase",
  "log",
  "tmp",
  "nofile",
  "scratch",
  "svn",
  "hgcommit",
}

resume_previous_cursor_position = function()
  local last_pos = vim.fn.line("'\"")
  if last_pos > 0 and last_pos <= vim.fn.line("$") then
    vim.cmd("normal! g`\"")
  end
end

M.buf_read_post_callback = function()
  local current_filetype = vim.bo.filetype

  if vim.tbl_contains(excluded_filetypes, current_filetype) then
    return false
  else
    resume_previous_cursor_position()
  end
end

M.setup = function()
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = M.buf_read_post_callback,
    desc = "Resume previous cursor position from Viminfo",
  })
end

return M
