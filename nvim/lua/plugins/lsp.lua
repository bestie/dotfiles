local arduino_setup = {
  cmd = {
    "arduino-language-server",
    "-cli-config", "$HOME/.arduinoIDE/arduino-cli.yaml",
    "-cli", "arduino-cli",
    "-clangd", "clangd",
    "-fqbn", "${FQBN-esp32:esp32:esp32}",
  },
  filetypes = { "arduino" },
  -- root_dir = lspconfig.util.root_pattern("platformio.ini", ".git"),
}

local toggle_diagnostic_location_list = function()
  local is_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype") == "qf" then
      is_open = true
      break
    end
  end

  if is_open then
    vim.cmd("lclose")
  else
    vim.diagnostic.setloclist()
    vim.cmd("set wrap")
    vim.cmd("wincmd p")
  end
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    "hrsh7th/cmp-nvim-lsp",  -- Add this for enhanced capabilities
  },
  config = function()
    require("neodev").setup()
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Keybindings
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename" })
    vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next Diagnostic" })
    vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Previous Diagnostic" })
    vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code Action" })
    vim.keymap.set("n", "<leader>dd", toggle_diagnostic_location_list, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap = true, silent = true })

    -- Open diagnostic float on hover
    vim.o.updatetime = 250
    vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

    vim.diagnostic.config({
      float = {
        wrap = true,
      },
    })

    -- Custom on_attach function
    local on_attach = function(client, bufnr)
      -- Enable logging (if needed)
      vim.lsp.set_log_level("debug")

      -- Additional LSP-specific keybindings or settings can go here
      -- Example: Set keybindings specific to this LSP client
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

      -- enable auto-formatting
      if client.capabilities.document_formatting then
        print("Setting up auto-formatting for " .. client.name)
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.buf.formatting()")
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap = true, silent = true })
      else
        print("Auto-formatting not supported for " .. client.name)
      end
    end

    -- Configure jdtls with enhanced capabilities and on_attach
    lspconfig.jdtls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        java = {
          project = {
            sourcePaths = { "src/main/java" },
          },
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = true,
          referencesCodeLens = true,
          inlayHints = {
            parameterNames = true,
          },
        },
      },
    })

    -- Other LSP configurations
    lspconfig.arduino_language_server.setup(arduino_setup)
    lspconfig.bashls.setup({})
    lspconfig.clangd.setup({
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--background-index",
        "--suggest-missing-includes",
        "--limit-references=0",
        "--limit-results=0",
        "-j=8"
      },
    })
    lspconfig.cmake.setup({})
    lspconfig.dockerls.setup({})
    lspconfig.lua_ls.setup({})
    lspconfig.ruby_lsp.setup({
      filetypes = { "ruby", "eruby", "Gemfile", "Gemfile.lock", "Rakefile", "config.ru" },
    })
    lspconfig.rust_analyzer.setup({})
    lspconfig.sqlls.setup({})
    lspconfig.vimls.setup({})
  end,
}
