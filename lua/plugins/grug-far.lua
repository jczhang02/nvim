-- ~/.config/nvim-new/lua/plugins/grug-far.lua
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
    keys = {
      { "<leader>sr", "<cmd>GrugFar<CR>", desc = "Search & replace" },
      -- Legacy <leader>S* aliases (capital S for grug-far)
      { "<leader>Ss", function() require("grug-far").open() end,                                                                 desc = "Search & replace panel" },
      { "<leader>Sp", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,             desc = "S&R word (project)" },
      { "<leader>Sp", mode = "v", function() require("grug-far").with_visual_selection() end,                                    desc = "S&R selection (project)" },
      { "<leader>Sf", function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end,                    desc = "S&R word (file)" },
    },
  },
}
