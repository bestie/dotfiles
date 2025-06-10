return {
	dir = "/Users/stephenbest/code/paneity.nvim",
	--  name = "paneity",
	dev = true,
  "bestie/paneity.nvim",
  config = function()
    paneity = require("paneity")
    paneity.setup({
      marker = "🥖🔥",
      split_direction = "horizontal",
      split_size_percentage = 35,
      keybindings = {
        toggle = "<leader>t",
        repeat_command = false,
      },
      -- close_pane_on_exit
      -- default_command
    })

    local save_then_repeat = function()
      vim.cmd("w!")
      paneity.repeat_command()
    end

    -- local commander = require("commander")
    -- commander.setup({
    --   runner = function(command)
    --     paneity.set_command(command)
    --     paneity.exec_in_pane(command)
    --   end
    -- })

    --  save before re-running the command
    vim.keymap.set("n", "<leader><leader>", save_then_repeat)
  end,
}

