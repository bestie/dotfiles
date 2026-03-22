local M = {}

local env_file_config = vim.env.RUBY_DEBUG_INIT_SCRIPT

local config = {
  toggle_key = "<leader>br",
  debugger_file = (env_file_config or ".rdbgrc"),
  gutter_glyph = "⏸️", -- also good: Ⓑ ●🫸
  sign_hl = "BreakpointSign",
  sign_hl_color = "#ff5555",
  line_hl = "BreakpointLine",
  line_hl_color = "#2a1a1a",
}

local ns = vim.api.nvim_create_namespace("breakpoints")
local breakpoints = {}
local project_root = nil

-- util

local function get_root()
  if project_root then return project_root end
  local cwd = vim.loop.cwd()
  project_root = cwd
  return project_root
end

local function normalize(path)
  local root = get_root()
  local abs = vim.fn.fnamemodify(path, ":p")
  return abs:gsub("^" .. vim.pesc(root) .. "/", "")
end

local function debugger_path()
  return get_root() .. "/" .. config.debugger_file
end

-- file io

local function read_file()
  breakpoints = {}
  local path = debugger_path()
  local f = io.open(path, "r")
  if not f then return end

  for line in f:lines() do
    local file, lnum = line:match("break (.+):(%d+)")
    if file and lnum then
      breakpoints[file] = breakpoints[file] or {}
      breakpoints[file][tonumber(lnum)] = true
    end
  end

  f:close()
end

local function write_file()
  local path = debugger_path()
  local f = io.open(path, "w")
  if not f then return end

  for file, lines in pairs(breakpoints) do
    for lnum, _ in pairs(lines) do
      f:write(string.format("break %s:%d\n", file, lnum))
    end
  end

  f:close()
end

-- core ops

function M.add(file, lnum)
  file = normalize(file)
  breakpoints[file] = breakpoints[file] or {}
  breakpoints[file][lnum] = true
  write_file()
end

function M.remove(file, lnum)
  file = normalize(file)
  if breakpoints[file] then
    breakpoints[file][lnum] = nil
    if vim.tbl_isempty(breakpoints[file]) then
      breakpoints[file] = nil
    end
  end
  write_file()
end

function M.toggle(file, lnum)
  file = normalize(file)
  if breakpoints[file] and breakpoints[file][lnum] then
    M.remove(file, lnum)
  else
    M.add(file, lnum)
  end
end

-- buffer wrappers

local function current_file()
  return vim.api.nvim_buf_get_name(0)
end

local function current_line()
  return vim.api.nvim_win_get_cursor(0)[1]
end

function M.add_here()
  M.add(current_file(), current_line())
end

function M.remove_here()
  M.remove(current_file(), current_line())
end

function M.toggle_here()
  M.toggle(current_file(), current_line())
  M.refresh_gutter(0)
end

-- gutter

local function place_sign(buf, lnum)
  vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
    sign_text = config.gutter_glyph,
    sign_hl_group = config.sign_hl,
    line_hl_group = config.line_hl or nil
  })
end

function M.refresh_gutter(buf)
  buf = buf or 0
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local file = normalize(vim.api.nvim_buf_get_name(buf))
  if not breakpoints[file] then return end

  for lnum, _ in pairs(breakpoints[file]) do
    place_sign(buf, lnum)
  end
end

-- setup

function M.setup(opts)
  config = vim.tbl_extend("force", config, opts or {})
  read_file()

  vim.api.nvim_set_hl(0, config.sign_hl, { fg = config.sign_hl_color, bold = true })
  vim.api.nvim_set_hl(0, config.line_hl, { bg = config.line_hl_color })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function(args)
      if vim.bo[args.buf].filetype == "ruby" then
        read_file()
        M.refresh_gutter(args.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.filetype == "ruby" then
        vim.keymap.set("n", config.toggle_key, M.toggle_here, { buffer = true })
      end
    end,
  })
end

return M
