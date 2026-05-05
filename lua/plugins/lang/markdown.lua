-- ~/.config/nvim-new/lua/plugins/lang/markdown.lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<F1>", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" },
    },
    opts = {
      heading = { sign = false },
      code = { width = "block", min_width = 60 },
    },
  },
}
