-- ~/.config/nvim-new/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", config = true, build = ":MasonUpdate" },
      "mason-org/mason-lspconfig.nvim",
      { "folke/neoconf.nvim", cmd = "Neoconf", priority = 100 },
      "Jint-lzxy/lsp_signature.nvim",
    },
    config = function()
      require("neoconf").setup()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = require("config.settings").lsp_deps,
        automatic_installation = true,
      })

      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim", "Snacks" } },
            completion = { callSnippet = "Replace" },
            hint = { enable = true },
          },
        },
      })

      vim.lsp.config("ruff", {
        init_options = { settings = { logLevel = "error" } },
      })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            usePlaceholders = true,
            staticcheck = true,
            analyses = { unusedparams = true },
            hints = {
              assignVariableTypes = true, compositeLiteralFields = true,
              constantValues = true, functionTypeParameters = true,
              parameterNames = true, rangeVariableTypes = true,
            },
          },
        },
      })

      vim.lsp.config("ts_ls", { single_file_support = true })
      vim.lsp.config("zuban", {})
      vim.lsp.config("bashls", {})
      vim.lsp.config("html", {})
      vim.lsp.config("jsonls", {})

      vim.lsp.enable(require("config.settings").lsp_deps)

      -- diagnostics
      vim.diagnostic.config({
        virtual_lines = require("config.settings").diagnostics_virtual_lines and { current_line = true } or false,
        virtual_text  = false,
        signs         = true,
        underline     = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      -- LspAttach: keymaps + signature + inlay hint
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local buf = ev.buf
          local map = function(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
          end
          map("gd", function() Snacks.picker.lsp_definitions() end,        "Go to definition")
          map("gD", vim.lsp.buf.declaration,                                "Go to declaration")
          map("gi", function() Snacks.picker.lsp_implementations() end,    "Go to implementation")
          map("gy", function() Snacks.picker.lsp_type_definitions() end,   "Go to type definition")
          map("gr", function() Snacks.picker.lsp_references() end,         "References")
          map("K",  vim.lsp.buf.hover,                                      "Hover")
          map("<C-k>", vim.lsp.buf.signature_help,                          "Signature help", { "i", "n" })
          map("<leader>rn", vim.lsp.buf.rename,                             "Rename")
          map("<leader>ca", vim.lsp.buf.code_action,                        "Code action", { "n", "v" })

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client then
            pcall(require("lsp_signature").on_attach, {
              bind = true, hint_enable = false,
              handler_opts = { border = "rounded" },
            }, buf)
            if client.server_capabilities.inlayHintProvider and require("config.settings").lsp_inlayhints then
              vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            end
          end
        end,
      })
    end,
  },
}
