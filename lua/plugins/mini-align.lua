-- ~/.config/nvim-new/lua/plugins/mini-align.lua
return {
  {
    "echasnovski/mini.align",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require("mini.align").setup(opts) end,
  },
}
