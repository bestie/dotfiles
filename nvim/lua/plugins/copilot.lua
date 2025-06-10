return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()

    local toggle_for_buffer = function()
      require("copilot.suggestion").toggle_auto_trigger()
      local  new_state = require("copilot.suggestion").auto_trigger
      print("[Copilot] Auto trigger is now " .. vim.inspect(new_state) .. " for this buffer")
    end

    vim.keymap.set("n", "<leader>cp",  toggle_for_buffer, {
      noremap = true,
      desc = "[C]o[p]ilot Toggle",
    })

    require("copilot").setup({
      attach = false,
      panel = {
        enabled = true,
        keymap = {
          open = "<M-p>",
          accept = "<CR>",
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<S-TAB>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-c>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
        },
      },
      filetypes = {
        -- yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    })
  end
}
