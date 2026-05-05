-- ~/.config/nvim-new/lua/plugins/glance.lua
return {
  {
    "DNLHC/glance.nvim",
    cmd = "Glance",
    keys = {
      { "<leader>lpd", "<cmd>Glance definitions<CR>",      desc = "Peek definitions" },
      { "<leader>lpr", "<cmd>Glance references<CR>",       desc = "Peek references" },
      { "<leader>lpi", "<cmd>Glance implementations<CR>",  desc = "Peek implementations" },
      { "<leader>lpt", "<cmd>Glance type_definitions<CR>", desc = "Peek type defs" },
    },
    opts = { border = { enable = true, top_char = "─", bottom_char = "─" } },
  },
}
