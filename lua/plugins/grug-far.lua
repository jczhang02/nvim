-- ~/.config/nvim-new/lua/plugins/grug-far.lua
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
    keys = {
      { "<leader>sr", "<cmd>GrugFar<CR>", desc = "Search & replace" },
    },
  },
}
