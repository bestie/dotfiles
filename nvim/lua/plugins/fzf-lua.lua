return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  enabled = true,
  lazy = false,
  keys = {
    { "<leader>f", ":FzfLua files<CR>", noremap = true, silent = true, desc = "Find files" },
    { "<c-p>", ":FzfLua files<CR>", noremap = true, silent = true, desc = "Find files" },
    { "<leader>rg", ":FzfLua live_grep<CR>", noremap = true, silent = true, desc = "Live grep" },
    { "<leader>fb", ":FzfLua buffers<CR>", noremap = true, silent = true, desc = "Find buffers" },
    { "<leader>fib", ":FzfLua blines<CR>", noremap = true, silent = true, desc = "Find in buffer " },
    { "<leader>fg", ":FzfLua git_files<CR>", noremap = true, silent = true, desc = "Find git files" },
    { "<leader>ll", ":FzfLua grep { search = vim.fn.input('GREP -> ') }<CR>", noremap = true, silent = true, desc = "Grep a word" },
    { "<leader>fs", ":FzfLua lsp_document_symbols<CR>", noremap = true, silent = true, desc = "Find LSP symbols" },
  },
  config = function()

    vim.keymap.set({"n", "v"}, "<leader>ca", require("fzf-lua").lsp_code_actions, { noremap = true, silent = true, desc = "Code Action" })

    require("fzf-lua").setup({
      fzf_opts = {},
      lsp = {
        prompt = 'LSP ',
        -- icons = {
        --   ['Error']       = { icon = '', color = 'red' },
        --   ['Warning']     = { icon = '', color = 'yellow' },
        --   ['Information'] = { icon = '', color = 'blue' },
        --   ['Hint']        = { icon = '󰌵', color = 'magenta' },
        -- },
        async_or_timeout = 3000,
      }
    })
  end
}
