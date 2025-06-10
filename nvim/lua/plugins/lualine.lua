return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = "onedark_dark"
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            'diff',
            colored = true,
            symbols = { added = '+', modified = '~', removed = '-' },
          }
        },
        lualine_c = { { 'filename', path=1, } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'nvim-tree' },
    }
  end,
}
