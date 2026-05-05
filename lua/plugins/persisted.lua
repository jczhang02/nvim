-- ~/.config/nvim-new/lua/plugins/persisted.lua
return {
  {
    "olimorris/persisted.nvim",
    event = "VimEnter",
    cmd = { "SessionToggle", "SessionStart", "SessionStop", "SessionSave", "SessionLoad", "SessionLoadLast", "SessionDelete" },
    opts = {
      autoload = false,
      use_git_branch = true,
      ignored_dirs = { "/tmp", "/var" },
    },
    keys = {
      { "<leader>ps", "<cmd>SessionSave<CR>",     desc = "Session save" },
      { "<leader>pl", "<cmd>SessionLoadLast<CR>", desc = "Session load last" },
      { "<leader>pt", "<cmd>SessionToggle<CR>",   desc = "Session toggle" },
      -- Legacy lowercase <leader>s* aliases (sessions)
      { "<leader>ss", "<cmd>SessionSave<CR>",     desc = "Session save (legacy)" },
      { "<leader>sl", "<cmd>SessionLoad<CR>",     desc = "Session load current (legacy)" },
      { "<leader>sd", "<cmd>SessionDelete<CR>",   desc = "Session delete (legacy)" },
    },
  },
}
