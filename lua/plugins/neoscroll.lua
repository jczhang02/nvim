-- ~/.config/nvim-new/lua/plugins/neoscroll.lua
return {
  {
    "karb94/neoscroll.nvim",
    event = { "CursorHold", "CursorHoldI" },
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      cursor_scrolls_alone = true,
      easing_function = "sine",
    },
  },
}
