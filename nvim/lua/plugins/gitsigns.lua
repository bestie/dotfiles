return {
  "lewis6991/gitsigns.nvim",
  opts = {
    -- Enable current line blame annotation
    current_line_blame = true,
    -- (optional) Customize blame appearance
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol', 'overlay', or 'right_align'
      delay = 300,           -- ms
      ignore_whitespace = false,
    },
    -- You can add other options here, see :h gitsigns-usage
  },
  -- optional: event = "BufReadPre", -- lazy-load for performance
}
