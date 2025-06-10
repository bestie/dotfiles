M = {}

local function guess_command(filename, line_number)
  local file_extension_command_map = {
    rb = function(filename, line_number)
      local command = "ruby " .. filename

      if filename:match("_spec%.rb$") then
        command = "rspec " .. filename
        if line_number then
          command = command .. ":" .. line_number
        end
      end

      if filename:match("_test%.rb$") then
        command = "ruby -I test -r test_helper.rb " .. filename
      end

      if vim.fn.filereadable("Gemfile.lock") > 0 then
        command = "bundle exec " .. command
      end
      return command
    end,
    rs = function()
      local command = "rustc " .. filename

      if filename:match("_spec%.rs$") then
        command = "cargo test"
      end

      if vim.fn.filereadable("Cargo.toml") > 0 then
        command = "cargo run"
      end
    end,
  }
  local extension = filename:match("%.([a-zA-Z0-9]+)$")

  print("Extension: " .. vim.inspect(extension))
  print("func: " .. vim.inspect(file_extension_command_map[extension]))

  local command = ""

  if extension then
    print("func: " .. vim.inspect(file_extension_command_map[extension]))
    local command_or_func = file_extension_command_map[extension]
    if type(command_or_func) == "function" then
      command = command_or_func(filename, line_number)
    end
   else
      command = "echo 'No command found for extension: `" .. extension .. "`"
  end

  -- local project_command_map = []
  -- project_command_map["Makefile"] = "make"
  -- project_command_map["cargo.toml"] = "cargo run"
  -- project_command_map["Gemfile"] = "bundle exec ruby"
  --
  -- local project_files = {}
  -- for _, file in ipairs(vim.fn.readdir(vim.fn.getcwd())) do
  --     project_files[file] = true
  -- end
  --
  -- if project_files["Makefile"] then
  --   command = "make"
  -- end

  print("Command: " .. command)
  return command
end

M.setup = function(opts)
  local default_runner = function(command)
    vim.cmd("!" .. command)
  end

  print("got runner: " .. vim.inspect(opts["runner"]))
  runner = opts["runner"] or default_runner

  vim.keymap.set("n", "<leader>x", function()
    local command = guess_command(vim.fn.expand("%"), vim.fn.line("."))
    print("Guess: " .. command)
    runner(command)
  end)
end

return M
