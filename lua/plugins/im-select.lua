-- ~/.config/nvim-new/lua/plugins/im-select.lua
return {
  {
    "keaising/im-select.nvim",
    event = "InsertEnter",
    opts = {
      default_im_select  = "keyboard-us",
      default_command    = vim.fn.executable("fcitx5-remote") == 1 and "fcitx5-remote" or nil,
      set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
    },
  },
}
