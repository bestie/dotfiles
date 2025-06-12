return {
  "bestie/paneity.nvim",
	-- name = "paneity",
	-- dev = true,
	-- dir = "/Users/stephenbest/code/paneity.nvim",
  config = function()
    local paneity = require("paneity")
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

    local guess_command = function()
      local filetype = vim.bo.filetype

      -- Makefile wins
      if vim.fn.filereadable("Makefile") == 1 then
        return "make"
      end

      if filetype == "ruby" then
        local prefix = ""
        if vim.fn.filereadable("Gemfile") == 1 then
          prefix = "bundle exec "
        end

        -- is a an RSpec file? (ends in _spec.rb)
        if vim.fn.expand("%:t"):match("_spec%.rb$") then
          return prefix .. "rspec " .. vim.fn.expand("%")
        else
          return prefix .. "ruby " .. vim.fn.expand("%")
        end
      elseif filetype == "sh" or filetype == "bash" then
        return "bash " .. vim.fn.expand("%")
      -- Docker
      elseif filetype == "dockerfile" then
        return "docker build ."
      -- C/C++
      elseif filetype == "c" or filetype == "cpp" then
        return "gcc " .. vim.fn.expand("%") .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r")
      else
        return ""
      end
    end

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

