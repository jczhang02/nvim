-- ~/.config/nvim-new/lua/plugins/lang/markdown.lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = { sign = false },
      code = { width = "block", min_width = 60 },
    },
  },
}
