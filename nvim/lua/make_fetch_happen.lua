
-- auto command for when the file type is ruby

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    -- define a user command for the current buffer

    vim.api.nvim_buf_create_user_command(0, function()
      -- vim.cmd("normal! ggVG")
      vim.cmd(":s/\[\(.\+\)]/.fetch(\1)/g")
    end, "MakeFetchHappen", {
      desc = "Convert Hash#[] to Hash#fetch"
    })
  end,
})


