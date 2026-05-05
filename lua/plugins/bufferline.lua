-- ~/.config/nvim-new/lua/plugins/bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = { "BufReadPre", "BufAdd", "BufNewFile" },
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_close_icon = false,
        show_buffer_close_icons = true,
        separator_style = "thin",
        offsets = {
          { filetype = "snacks_layout_box", text = "Explorer", text_align = "center", separator = true },
        },
      },
    },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",            desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close non-pinned" },
      { "[b",         "<cmd>BufferLineCyclePrev<CR>",            desc = "Prev buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<CR>",            desc = "Next buffer" },
    },
  },
}
