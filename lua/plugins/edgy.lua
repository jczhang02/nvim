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
        { title = "Explorer", ft = "snacks_layout_box", size = { width = 0.2 } },
      },
      right = {},
    },
  },
}
