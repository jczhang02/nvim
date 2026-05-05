-- ~/.config/nvim-new/lua/plugins/fugitive.lua
return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gblame" },
    keys = {
      { "<leader>gg", "<cmd>Git<CR>",        desc = "Git status" },
      { "<leader>gB", "<cmd>Git blame<CR>",  desc = "Git blame" },
      { "<leader>gP", "<cmd>Git push<CR>",   desc = "Git push" },
    },
  },
}
