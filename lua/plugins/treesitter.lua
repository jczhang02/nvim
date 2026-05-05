-- ~/.config/nvim-new/lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      if #vim.api.nvim_list_uis() > 0 then vim.cmd("TSUpdate") end
    end,
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      local langs = require("config.settings").treesitter_deps
      ts.install(langs):await(function() end)
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
          require("nvim-treesitter-textobjects").setup({
            select = { lookahead = true },
            move   = { set_jumps = true },
          })
          local map = function(m, lhs, rhs, desc)
            vim.keymap.set(m, lhs, rhs, { desc = desc, silent = true })
          end
          local sel = "require('nvim-treesitter-textobjects.select').select_textobject"
          map({ "x", "o" }, "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end, "Function outer")
          map({ "x", "o" }, "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end, "Function inner")
          map({ "x", "o" }, "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer",   "textobjects") end, "Class outer")
          map({ "x", "o" }, "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner",   "textobjects") end, "Class inner")
          -- Swap (legacy)
          map("n", "<leader>za", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end, "Swap parameter.inner")
          map("n", "<leader>zA", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.outer") end, "Swap parameter.outer")
          -- Move (legacy)
          local move = require("nvim-treesitter-textobjects.move")
          map({ "n", "x", "o" }, "][", function() move.goto_next_start("@function.outer", "textobjects") end, "Next function start")
          map({ "n", "x", "o" }, "]m", function() move.goto_next_start("@class.outer",    "textobjects") end, "Next class start")
          map({ "n", "x", "o" }, "]]", function() move.goto_next_end("@function.outer",   "textobjects") end, "Next function end")
          map({ "n", "x", "o" }, "]M", function() move.goto_next_end("@class.outer",      "textobjects") end, "Next class end")
          map({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@function.outer", "textobjects") end, "Prev function start")
          map({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@class.outer",    "textobjects") end, "Prev class start")
          map({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@function.outer",   "textobjects") end, "Prev function end")
          map({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@class.outer",      "textobjects") end, "Prev class end")
          local rep = require("nvim-treesitter-textobjects.repeatable_move")
          map({ "n", "x", "o" }, ";", function() rep.repeat_last_move_next() end, "Repeat last move")
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = { max_lines = 4, multiline_threshold = 4, mode = "cursor" },
      },
      {
        "andymass/vim-matchup",
        init = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
      },
      { "windwp/nvim-ts-autotag", opts = {} },
      {
        "hiphish/rainbow-delimiters.nvim",
        submodules = false,
        config = function()
          local rainbow = require("rainbow-delimiters")
          vim.g.rainbow_delimiters = {
            strategy = { [""] = rainbow.strategy["global"] },
            query    = { [""] = "rainbow-delimiters" },
            highlight = {
              "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
              "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet",
              "RainbowDelimiterCyan",
            },
          }
        end,
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
        init = function()
          local get_option = vim.filetype.get_option
          vim.filetype.get_option = function(filetype, option)
            return option == "commentstring"
              and require("ts_context_commentstring.internal").calculate_commentstring()
              or get_option(filetype, option)
          end
        end,
      },
    },
  },
}
