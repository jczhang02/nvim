-- ~/.config/nvim-new/lua/plugins/flash.lua
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,        desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,  desc = "Flash TS" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote flash" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "TS search" },
      -- Legacy hop equivalents
      { "<leader>jw", mode = { "n", "v" }, function() require("flash").jump() end,                                  desc = "Jump to word" },
      { "<leader>jj", mode = { "n", "v" }, function() require("flash").jump({ search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" }) end, desc = "Jump to line" },
      { "<leader>jk", mode = { "n", "v" }, function() require("flash").jump({ search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" }) end, desc = "Jump to line" },
      { "<leader>jc", mode = { "n", "v" }, function() require("flash").jump({ search = { mode = function(s) return ("\\<%s"):format(s) end } }) end, desc = "Jump 1 char" },
      { "<leader>jC", mode = { "n", "v" }, function() require("flash").jump() end,                                  desc = "Jump 2 chars" },
    },
  },
}
