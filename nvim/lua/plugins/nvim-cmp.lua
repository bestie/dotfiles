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
    -- {
    --   "zbirenbaum/copilot-cmp",
    --   config = function ()
    --     require("copilot_cmp").setup()
    --
    --     -- disable co-pilot suggestions and panel (put this in co-pilot config)
    --    require("copilot").setup({
    --      suggestion = { enabled = false },
    --      panel = { enabled = false },
    --    })
    --   end
    -- },
    -- "L3MON4D3/LuaSnip",
    -- "hrsh7th/cmp-calc",
    -- "saadparwaiz1/cmp_luasnip",
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
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = "buffer" },
        { name = "dictionary" },
        { name = "emoji" },
        { name = "nvim_lsp" },
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
