local max_filesize = 100 * 1024 -- 100 KB
local file_exceeds_max_size = function(_lang, buf)
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

-- Temporary fix for https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
vim.cmd('autocmd FileType ruby setlocal indentkeys-=.')

return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  dependencies = {
    "andymass/vim-matchup",
    "metiulekm/nvim-treesitter-endwise",
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  opts = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ignore_install = {},
      ensure_installed = {
        "arduino",
        "bash",
        "c",
        "dockerfile",
        "earthfile",
        "embedded_template",
        "fish",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitcommit",
        "gitignore",
        "gitignore",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "lua",
        "luap",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "rbs",
        "regex",
        "ruby",
        "rust",
        "sql",
        "tmux",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
        "zig",
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      refactor = {
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = "<c-]>",
            goto_next_usage = "]]",
            goto_previous_usage = "[[",
          },
        },
        highlight_definitions = {
          enable = true,
          disable = function(lang, buffer)
            local skip = { "help" }

            return vim.api.nvim_buf_line_count(buffer) > 20000 or vim.tbl_contains(skip, lang)
          end,
          clear_on_cursor_move = true,
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "R",
          },
        },
      },
      highlight = {
        enable = true,
        disable = file_exceeds_max_size,
      },
      autotag = { enable = false },
      matchup = {
        enable = true,
        disable = file_exceeds_max_size,
      },
      indent = { enable = true },
      endwise = { enable = true },
    })
  end,
}
