return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-buffer",
    -- "uga-rosa/cmp-dictionary",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-nvim-lsp",
    "ray-x/cmp-treesitter",
    -- "hrsh7th/cmp-omni",
    "delphinus/cmp-ctags",
  },
  config = function()
    local cmp = require('cmp')
    require("cmp").setup {
      -- snippet = {
      --   expand = function(args)
      --     require("luasnip").lsp_expand(args.body)
      --   end,
      -- },
      mapping = cmp.mapping.preset.insert({
        ['<M-Space>'] = cmp.mapping.complete(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-c>'] = cmp.mapping.abort(),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "dictionary" },
        { name = "emoji" },
        { name = "treesitter" },
        -- { name = 'omni',
        --   option = {
        --     disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
        --   },
        -- },
        {
          name = "ctags",
          -- default values
          option = {
            executable = "ctags",
            trigger_characters = { "." },
            trigger_characters_ft = {},
          },
        },
        -- { name = "calc" },
        -- { name = "luasnip" },
      },
    }
  end,
}
