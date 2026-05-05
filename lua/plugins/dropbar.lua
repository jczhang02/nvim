-- ~/.config/nvim-new/lua/plugins/dropbar.lua
return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>;", function() require("dropbar.api").pick() end, desc = "Dropbar pick" },
    },
  },
}
