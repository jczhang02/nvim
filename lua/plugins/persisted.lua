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
    },
  },
}
