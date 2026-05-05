-- ~/.config/nvim-new/lua/plugins/todo-comments.lua
return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    opts = { signs = true },
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<CR>", desc = "Todo (compat)" },
      { "<leader>sT", function() Snacks.picker.todo_comments() end, desc = "Todo (snacks)" },
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    },
  },
}
