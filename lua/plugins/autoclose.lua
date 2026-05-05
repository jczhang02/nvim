-- ~/.config/nvim-new/lua/plugins/autoclose.lua
return {
  {
    "m4xshen/autoclose.nvim",
    event = "InsertEnter",
    opts = { options = { disable_when_touch = true } },
  },
}
