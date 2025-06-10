-- vim.cmd('command! SUDOW execute "silent! write !sudo tee %" | edit!')

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altfile = 1
vim.g.netrw_altv = 1
vim.g.netrw_browse_split = 2 -- 1 hs, 2 vs, 3 tab, 4 previous window
vim.g.netrw_list_hide = 0

vim.opt.number = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.ruler = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.winwidth = 80
vim.opt.swapfile = false
vim.opt.scrolloff=8
vim.opt.sidescrolloff=8
vim.opt.virtualedit="block,insert,onemore"
vim.opt.colorcolumn="80"
vim.opt.winwidth=90
vim.opt.listchars="eol:¬,tab:⇤–⇥,space:·,trail:☃,precedes:⇠,extends:⇢,nbsp:×"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitright = true
vim.opt.re=1
vim.opt.wrap=false

vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

vim.opt.completeopt = "menuone,noinsert,noselect"

vim.cmd([[command! W :write]])
vim.cmd([[command! Q :quit]])

vim.cmd("source " .. vim.fn.stdpath("config") .. "/lua/set.vim")

vim.cmd("colorscheme onedark_dark")


-- stop warning me about files changing when they haven't
vim.opt.writebackup = false
vim.opt.autoread = true
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
    pattern = "*",
    command = "checktime",
})
