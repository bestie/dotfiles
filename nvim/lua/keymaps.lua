local function opts(description)
  return { noremap = true, silent = true, desc = description }
end

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
vim.keymap.set("n", "<leader>ya", [[ggVG]], opts("[Y]ank [a]ll"))

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

vim.keymap.set('n', '<leader>rbp', [[Obinding.irb; # DEBUG @bestie<cr><esc>]], opts("Ruby: insert a breakpoint"))
local tap_and_irb = ".tap { |obj| binding.irb }"
vim.keymap.set('n', '<leader>rtp', [[o]] .. tap_and_irb .. [[<esc>==]], opts("Ruby: insert a breakpoint within tap"))

local function save_and_reload()
    vim.cmd("write")
    vim.cmd("source %")
    vim.notify("Reloaded: " .. vim.fn.expand("%:."), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>so", save_and_reload , opts("Source current file"))
vim.keymap.set("n", "<leader>mv", require("mv_file").mv_file, opts("[M]o[v]e current file"))

-- Select all
vim.keymap.set("n", "<leader>va", "gg<S-v>G", opts("[V]isual select [a]ll"))
-- Copy whole buffer to paste buffer
vim.keymap.set("n", "<leader>ya", "gg<S-v>G\"+y<c-o>", opts("[Y]ank [a]ll"))

local toggle_diagnostic_location_list = function()
  local is_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype") == "qf" then
      is_open = true
      break
    end
  end

  if is_open then
    vim.cmd("lclose")
  else
    vim.diagnostic.setloclist()
    vim.cmd("set wrap")
    vim.cmd("wincmd p")
  end
end

vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Previous Diagnostic" })
vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code Action" })
vim.keymap.set("n", "<leader>dd", toggle_diagnostic_location_list, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap = true, silent = true })

-- Esc closes all popups
vim.keymap.set("n", "<Esc>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end)

vim.keymap.set({"n", "v"}, "<leader>'", [[:s/"/'/g<cr>]], opts("Replace double quotes with single quotes"))
vim.keymap.set({"n", "v"}, '<leader>"', [[:s/'/"/g<cr>]], opts("Replace single quotes with double quotes"))
