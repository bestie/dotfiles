local palette = {
  bg = "#000000",
  bg1 = "#111111",
  bg2 = "#333333",
  fg = "#abb2bf",
  red = "#ff005f",
  orange = "#ff5f00",
  yellow = "#d7ff00",
  green = "#5fff00",
  cyan = "#00ffff",
  blue = "#ff5f5f", -- no blue
  purple = "#ff00ff",
  white = "#ffffd7",
  black = "#1c1c1c",
  gray = "#444444",
  highlight = "#d7ff00",
  comment = "#ff5f00",
  none = "NONE",
}
local c = palette

return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    opts = {
      themes = {
        -- vaporwave = "/Users/stephenbest/.config/nvim/lua/vaporwave.lua"
      },
      colors = {
        onedark_dark = palette,
      },
      highlights = {
        CursorLineNr = { fg = c.yellow, bg = c.bg0, style = c.none },
        CursorLine = { bg = c.bg0, style = "nocombine" },
        ColorColumn = { bg = c.red },
        Comment = { fg = c.comment, bg = c.bg0, style = "italic" },
        SpecialComment = { fg = c.bg0, bg = c.none, style = "italic" },
      },
      styles = {
        tags = "italic",
        comments = "italic",
        virtual_text = "italic",
      },
      options = {
        terminal_colors = true,
        cursorline = true,
        -- highlight_inactive_windows = true,
      },
    },
  },
}
