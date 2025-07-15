return {
  -- "bestie/paneity.nvim",
	name = "paneity",
	dev = true,
	dir = "/Users/stephenbest/code/paneity.nvim",
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
      elseif filetype == "rust" then
        if vim.fn.filereadable("Cargo.toml") == 1 then
          return "cargo test"
        else
          return "rustc " .. vim.fn.expand("%") .. " && ./" .. vim.fn.expand("%:r")
        end
      elseif filetype == "sh" or filetype == "bash" then
        return "bash " .. vim.fn.expand("%")
      elseif filetype == "dockerfile" then
        return "docker build ."
      elseif filetype == "c" or filetype == "cpp" then
        return "gcc " .. vim.fn.expand("%") .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r")
      else
        return ""
      end
    end

    local add_cursor_line_number = function(command)
      local line_number = vim.fn.line(".")

      -- if command contains rspec and ends with _spec.rb
      if command:match("rspec") and command:match("_spec%.rb$") then
        command = command .. ":" .. line_number
      else
        -- show an error to the user
        vim.notify("Command does not support line numbers: " .. command, vim.log.levels.ERROR)
      end

      return command
    end

    local run_with_line_number = function()
      local command = guess_command()
      command = add_cursor_line_number(command)

      vim.cmd("w!")
      paneity.run(command)
    end

    local save_then_repeat = function()
      if paneity.previous_command == "" then
        local command = guess_command()
        paneity.run(command)
        return
      end
      vim.cmd("w!")
      paneity.repeat_command()
    end

    vim.keymap.set("n", "<leader><leader>", save_then_repeat)
    vim.keymap.set("n", "<leader>l", run_with_line_number, { desc = "Run with line number" })
  end,
}

