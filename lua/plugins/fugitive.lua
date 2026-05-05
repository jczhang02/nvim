-- ~/.config/nvim-new/lua/plugins/fugitive.lua
return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gblame" },
    keys = {
      { "<leader>gB", "<cmd>Git blame<CR>",  desc = "Git blame" },
      { "<leader>gP", "<cmd>Git push<CR>",   desc = "Git push" },
      { "<leader>gG", "<cmd>Git<CR>",        desc = "Git fugitive" },
      { "gps",        "<cmd>G push<CR>",     desc = "Git push" },
      { "gpl",        "<cmd>G pull<CR>",     desc = "Git pull" },
    },
  },
}
