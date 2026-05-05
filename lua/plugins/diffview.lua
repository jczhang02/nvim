-- ~/.config/nvim-new/lua/plugins/diffview.lua
return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",        desc = "Diffview open" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>",       desc = "Diffview close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
    },
    opts = {},
  },
}
