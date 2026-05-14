return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  },
  lazy = false,
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- neotree doesn't re-expand its width after being squashed when other panes
    -- focus and expand to the set winwidth, so we must tell it to expand on focus
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.bo.filetype == "neo-tree" then
          local current_width = vim.api.nvim_win_get_width(0)
          if current_width < opts.window.width then
            vim.api.nvim_win_set_width(0, opts.window.width)
          end
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = false,
    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = "✖", -- this can only be used in the git_status source
        renamed = "󰁕", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",
        conflict = "",
      },
    },
    window = {
      width = 30,
      mappings = {
        ["<space>"] = {
          "toggle_node",
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["<esc>"] = "cancel", -- close preview or floating neo-tree window
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        ["v"] = { "open_rightbelow_vs" },
        ["V"] = { "open_leftabove_vs" },
      },
    },
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        position = "left",
      }
    }
  }
}
