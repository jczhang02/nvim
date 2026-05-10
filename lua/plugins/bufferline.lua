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
          { filetype = "neo-tree", text = "Explorer", text_align = "center", separator = true },
        },
      },
    },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",            desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close non-pinned" },
      { "[b",         "<cmd>BufferLineCyclePrev<CR>",            desc = "Prev buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<CR>",            desc = "Next buffer" },
      { "<A-i>",      "<cmd>BufferLineCycleNext<CR>",            desc = "Buffer next" },
      { "<A-o>",      "<cmd>BufferLineCyclePrev<CR>",            desc = "Buffer prev" },
      { "<A-S-i>",    "<cmd>BufferLineMoveNext<CR>",             desc = "Move buffer to next" },
      { "<A-S-o>",    "<cmd>BufferLineMovePrev<CR>",             desc = "Move buffer to prev" },
      { "<leader>be", "<cmd>BufferLineSortByExtension<CR>",      desc = "Sort by extension" },
      { "<leader>bs", "<cmd>BufferLineSortByDirectory<CR>",      desc = "Sort by directory" },
      { "<A-1>",      "<cmd>BufferLineGoToBuffer 1<CR>",         desc = "Goto buffer 1" },
      { "<A-2>",      "<cmd>BufferLineGoToBuffer 2<CR>",         desc = "Goto buffer 2" },
      { "<A-3>",      "<cmd>BufferLineGoToBuffer 3<CR>",         desc = "Goto buffer 3" },
      { "<A-4>",      "<cmd>BufferLineGoToBuffer 4<CR>",         desc = "Goto buffer 4" },
      { "<A-5>",      "<cmd>BufferLineGoToBuffer 5<CR>",         desc = "Goto buffer 5" },
      { "<A-6>",      "<cmd>BufferLineGoToBuffer 6<CR>",         desc = "Goto buffer 6" },
      { "<A-7>",      "<cmd>BufferLineGoToBuffer 7<CR>",         desc = "Goto buffer 7" },
      { "<A-8>",      "<cmd>BufferLineGoToBuffer 8<CR>",         desc = "Goto buffer 8" },
      { "<A-9>",      "<cmd>BufferLineGoToBuffer 9<CR>",         desc = "Goto buffer 9" },
    },
  },
}
