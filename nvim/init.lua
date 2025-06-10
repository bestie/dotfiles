vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

require("set")
require("keymaps")
require("hard_case").setup()
require("resume_position").setup()
require("hard_case").setup()

-- TODO
-- [x] undo tree
-- [c] move files
-- [ ] completion
-- [ ] default command
-- [ ] paneity map keys on bufenter
-- [ ] Fzf live grep search for word under cursor
-- [ ] Fzf live grep set search, then search file names
-- [x] abolish
-- [x] save and reload
-- [x] restore cursor position
-- [x] readline
-- [x] livable color scheme
