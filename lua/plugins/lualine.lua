-- ~/.config/nvim-new/lua/plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        theme = "catppuccin-latte",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators   = { left = "",  right = ""  },
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          { "diagnostics", sources = { "nvim_diagnostic" } },
          { "filename", path = 1, symbols = { modified = " ●", readonly = " " } },
        },
        lualine_x = {
          { function() local ok, c = pcall(require, "noice"); return ok and c.api.status.command.has() and c.api.status.command.get() or "" end, cond = function() local ok = pcall(require, "noice"); return ok end },
          "encoding", "fileformat", "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "mason", "trouble", "quickfix" },
    },
  },
}
