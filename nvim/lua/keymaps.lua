local function opts(description)
  return { noremap = true, silent = true, desc = description }
end

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("i", "<C-c>", [[<Esc>:nohlsearch<cr><Esc>]], { desc = "ESC (and clear highlight)" })
vim.keymap.set({'n', 'i'}, '<C-l>', ':nohlsearch<cr><C-l>', { desc = "Redraw screen (and clear highlight)" })
vim.keymap.set('n', '<leader>/', ':nohlsearch<cr>', { desc = "Clear highlight" })
vim.keymap.set('i', '<C-l>', '<Esc>:nohl<cr>:redraw<cr>', { desc = "Redraw +(nohl)" })
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)
vim.keymap.set("n", "Q", "<nop>")

-- Good copy and paste
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], opts("[Y]ank to clipboard"))
vim.keymap.set("n", "<leader>yy", [["+yy]], opts("[Y]ank line to clipboard"))
vim.keymap.set("n", "<leader>Y", [["+y$]], opts("[Y]ank end of line to clipboard"))
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]], opts("[P]aste from clipboard"))
vim.keymap.set("n", "<leader>P", [["+P]], opts("[P]aste before cursor from clipboard"))

-- Resize windows in increments of 5
vim.keymap.set("n", "<C-w>.", ":vertical resize +5<CR>", opts("Increase window height +5"))
vim.keymap.set("n", "<C-w>,", ":vertical resize -5<CR>", opts("Decrease window height -5"))
vim.keymap.set("n", "<C-w>+", ":resize +5<CR>", opts("Increase window width +5"))
vim.keymap.set("n", "<C-w>-", ":resize -5<CR>", opts("Decrease window width -5"))

vim.keymap.set({"i", "n"}, "<C-s>", "<Esc>:w<CR>:echo '💾👍'<CR>", opts("Save buffer"))

-- Expand %% to directory of the buffer
vim.cmd([[cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%']])

-- Stay centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", "*", "<esc>:let @/ = \"<C-r><C-w>\"<cr>:set hlsearch<cr>", opts("Search for word under cursor without advanncing"))
-- vim.keymap.set('n', '<leader>e', [[<cmd>:wall<cr><cmd>lua default_command()<cr>]], opts("[E]xecute default command for file type (save all)"))

vim.keymap.set("n", "_", "f_", opts("Jump to next underscore"))
vim.keymap.set("n", "-", "F_", opts("Jump to prev underscore"))

vim.keymap.set('n', '<leader>rbp', [[Orequire "pry"; binding.pry; # DEBUG @bestie<cr><esc>]], opts("Ruby: insert pry breakpoint"))
local tap_and_pry = ".tap { require 'pry'; binding.pry }"
vim.keymap.set('n', '<leader>rtp', [[o]] .. tap_and_pry .. [[<esc>==]], opts("Ruby: insert pry breakpoint within tap"))

local function save_and_reload()
    vim.cmd("write")
    vim.cmd("source %")
    vim.notify("Reloaded: " .. vim.fn.expand("%:."), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>so", save_and_reload , opts("Source current file"))
-- vim.keymap.set("n", "<leader>mv", require("mv_file").mv_file, opts("[M]o[v]e current file"))

-- Select all
vim.keymap.set("n", "<leader>va", "gg<S-v>G", opts("[V]isual select [a]ll"))
-- Copy whole buffer to paste buffer
vim.keymap.set("n", "<leader>ya", "gg<S-v>G\"+y<c-o>", opts("[Y]ank [a]ll"))
