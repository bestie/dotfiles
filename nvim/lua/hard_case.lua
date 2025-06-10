local M = {
  name = "HardCase",
  version = "0.1.0",
}

local format_matchers = {
    snake = "^[a-z]+_[a-z_]+$",
    screaming_snake = "^[A-Z]+_[A-Z_]+$",
    kebab = "^[a-z]+-[a-z-]+$",
    camel = "^[a-z]+[A-Za-z]*$",
    upper_camel = "^[A-Z][a-zA-Z]*$",
}

local split_patters = {
    snake = "[^_]+",
    screaming_snake = "[^_]+",
    kebab = "[^-]+",
    camel = "[A-Z]?[a-z]+",
    upper_camel = "[A-Z][a-z]*",
}

local format_functions = {
    camel = function(words)
        return words[1] .. table.concat(vim.tbl_map(function(w) return w:sub(1, 1):upper() .. w:sub(2) end, vim.list_slice(words, 2)))
    end,
    upper_camel = function(words)
        return table.concat(vim.tbl_map(function(w) return w:sub(1, 1):upper() .. w:sub(2) end, words))
    end,
    snake = function(words)
        return table.concat(words, "_")
    end,
    kebab = function(words)
        return table.concat(words, "-")
    end,
    screaming_snake = function(words)
        return table.concat(words, "_"):upper()
    end,
}

local function detect_format(str)
    for format, regex in pairs(format_matchers) do
        if str:match(regex) then
            return format
        end
    end
    -- print("Unknown format: " .. str)
    return nil -- Unknown format
end

local function string_to_word_list(str)
    local words = {}
    format = detect_format(str)
    split_pattern = split_patters[format]
    -- print("splitting string: " .. str .. " detected format: " .. format, "split pattern: " .. split_pattern)

    for word in string.gmatch(str, split_pattern) do
      table.insert(words, word:lower())
    end

    -- print("words: ", vim.inspect(words))
    return words
end

function M.transform(input, target_format)
    local words = string_to_word_list(input)
    if not format_functions[target_format] then
        vim.notify("Invalid target format: " .. target_format, vim.log.levels.ERROR)
        return input
    end
    local transformed_string = format_functions[target_format](words)
    -- print("Transformed: " .. input .. " -> " .. transformed_string)
    return transformed_string
end

-- Command to apply transformation to the word under cursor
function M.transform_word_under_cursor(target_format)
    local word = vim.fn.expand("<cword>")
    local transformed = M.transform(word, target_format)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal ciw" .. transformed)
    vim.api.nvim_win_set_cursor(0, cursor_pos)
end

function M.command_handler(args)
    local target_format = args.args:lower()
    if not format_functions[target_format] then
        local formats = vim.tbl_keys(format_functions)
        vim.notify("Invalid format. Use one of: " .. table.concat(formats, ", "), vim.log.levels.ERROR)
        return
    end
    M.transform_word_under_cursor(target_format)
end

-- Setup function
function M.setup()
    vim.api.nvim_create_user_command(
        "CamelSnake",
        function(args) M.command_handler(args) end,
        { nargs = 1, complete = function() return vim.tbl_keys(format_functions) end }
    )

    local format_to_keymap = {
      camel = "crc",
      upper_camel = "crC",
      snake = "cr_",
      screaming_snake = "crS",
      kebab = "cr-",
    }

    local function keymap_opts(target_format)
      return {
        noremap = true,
        silent = true,
        desctransform= "Transform word under cursor to " .. target_format,
      }
    end

    for format, key in pairs(format_to_keymap) do
      vim.keymap.set("n", key, function() M.transform_word_under_cursor(format) end)
    end
end

return M
