-- ~/.config/nvim-new/lua/plugins/debugprint.lua
return {
  {
    "andrewferrier/debugprint.nvim",
    cmd = { "DebugPrint", "ToggleCommentDebugPrints", "DeleteDebugPrints" },
    opts = {},
    keys = {
      { "g?p", desc = "Debug print below" },
      { "g?P", desc = "Debug print above" },
    },
  },
}
