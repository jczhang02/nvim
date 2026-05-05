-- ~/.config/nvim-new/lua/plugins/trouble.lua
return {
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = { auto_close = true, focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                          desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",             desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",                  desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",   desc = "LSP defs/refs/..." },
      { "<leader>xL", "<cmd>Trouble loclist toggle<CR>",                              desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>",                               desc = "Quickfix list" },
    },
  },
}
