
local function format()
  -- pipe the current buffer through rubyfmt
  local buf = vim.api.nvim_get_current_buf()
  local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local rubyfmt = vim.fn.exepath("rubyfmt")
  if rubyfmt == "" then
    print("rubyfmt not found in PATH")
    return
  end

  local formatted_buffer = ""
  local errors = ""

  local job = vim.fn.jobstart(rubyfmt, {
    stdin = "pipe",
    stdout = "pipe",
    stderr = "pipe",
    on_stdout = function(_, data, _)
      if data then
        formatted_buffer = formatted_buffer .. table.concat(data, "\n")
      end
    end,
    on_stderr = function(_, data, _)
      if data and #data > 0 then
        errors = errors .. table.concat(data, "\n")
      end
    end,
  })

  vim.fn.chansend(job, content)
  vim.fn.chanclose(job, "stdin")
  vim.fn.jobwait({ job }, -1)

  -- on success replace buffer with formatted version

  if errors ~= "" then
    print("rubyfmt error: " .. errors)
    return
  end

  local formatted_lines = vim.split(formatted_buffer, "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_lines)
end

return {
  setup = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "ruby",
      callback = function()
        -- Run the current buffer through rubyfmt
        vim.keymap.set("n", "<leader>rf", format, { buffer = true, desc = "Format with rubyfmt" })
      end
    })
  end
}
