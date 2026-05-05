-- ~/.config/nvim-new/lua/plugins/colorscheme.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    transparent_background = false,
    show_end_of_buffer = false,
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      treesitter = true,
      treesitter_context = true,
      mason = true,
      native_lsp = { enabled = true },
      indent_blankline = { enabled = false },
      which_key = true,
      flash = true,
      neogit = false,
      dap = true,
      dap_ui = true,
      diffview = true,
      lsp_trouble = true,
      rainbow_delimiters = true,
      render_markdown = true,
      snacks = { enabled = true },
      bufferline = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme(require("config.settings").colorscheme)
  end,
}
