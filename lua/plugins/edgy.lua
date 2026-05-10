-- ~/.config/nvim-new/lua/plugins/edgy.lua
return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      bottom = {
        { ft = "trouble",      title = "Trouble" },
        { ft = "qf",           title = "QuickFix" },
        { ft = "help",         title = "Help",       size = { height = 20 }, filter = function(buf) return vim.bo[buf].buftype == "help" end },
        { ft = "spectre_panel",size = { height = 0.4 } },
      },
      left = {
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
          size = { width = 0.2 },
        },
        { title = "Neo-Tree Buffers",    ft = "neo-tree", filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end },
        { title = "Neo-Tree Git Status", ft = "neo-tree", filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end },
      },
      right = {},
    },
  },
}
