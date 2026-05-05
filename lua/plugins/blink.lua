-- ~/.config/nvim-new/lua/plugins/blink.lua
return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = vim.fn.stdpath("config") .. "/snips",
          })
          require("luasnip.loaders.from_lua").lazy_load({
            paths = vim.fn.stdpath("config") .. "/lua/snippets",
          })
        end,
      },
      "ribru17/blink-cmp-spell",
      "mgalliou/blink-cmp-tmux",
      "erooke/blink-cmp-latex",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "luasnip" },
      keymap = {
        preset = "none",
        ["<C-p>"]   = { "select_prev", "fallback" },
        ["<C-n>"]   = { "select_next", "fallback" },
        ["<C-d>"]   = { "scroll_documentation_up" },
        ["<C-f>"]   = { "scroll_documentation_down" },
        ["<C-w>"]   = { "hide" },
        ["<Tab>"]   = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"]    = { "accept", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = (function()
          local icons = require("config.icons")
          local kind = icons.kind or {}
          local typ  = icons.type or {}
          local cmp  = icons.cmp or {}
          return vim.tbl_deep_extend("force", {}, kind, typ, cmp)
        end)(),
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = {
            { "┌", "PmenuBorder" }, { "─", "PmenuBorder" }, { "┐", "PmenuBorder" },
            { "│", "PmenuBorder" }, { "┘", "PmenuBorder" }, { "─", "PmenuBorder" },
            { "└", "PmenuBorder" }, { "│", "PmenuBorder" },
          },
          winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:PmenuSel",
          scrollbar = false,
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            components = {
              label = {
                width = { max = 80 },
                ellipsis = true,
              },
            },
          },
        },
        documentation = {
          auto_show = true, auto_show_delay_ms = 200,
          window = {
            border = "rounded",
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
          },
        },
        ghost_text = { enabled = true, show_with_menu = false },
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer", "spell" },
        per_filetype = {
          tex      = { "lsp", "latex", "snippets", "path", "buffer", "spell" },
          bib      = { "lsp", "latex", "snippets", "path", "buffer" },
          markdown = { "lsp", "snippets", "path", "buffer", "spell" },
        },
        providers = {
          lsp      = { name = "[LSP]",   score_offset = 90 },
          snippets = { name = "[SNIP]",  score_offset = 80 },
          path     = { name = "[PATH]",  score_offset = 70 },
          buffer   = {
            name = "[BUF]", score_offset = 50,
            opts = {
              get_bufnrs = function()
                return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
              end,
            },
          },
          spell    = { name = "[SPELL]", module = "blink-cmp-spell", score_offset = 30 },
          tmux     = { name = "[TMUX]",  module = "blink-cmp-tmux",  score_offset = 40 },
          latex    = { name = "[LTEX]",  module = "blink-cmp-latex", score_offset = 60 },
        },
      },
      cmdline = {
        keymap = { preset = "cmdline" },
        completion = { menu = { auto_show = true } },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = false },
    },
  },
}
