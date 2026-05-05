-- ~/.config/nvim-new/lua/plugins/lang/latex.lua
return {
  {
    "lervag/vimtex",
    ft = { "tex", "bib" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_imaps_enabled = 0       -- LuaSnip handles snippets
      vim.g.vimtex_complete_enabled = 1
    end,
    keys = {
      { "<leader>ll", "<cmd>VimtexCompile<CR>", ft = { "tex", "bib" }, desc = "Vimtex compile" },
    },
  },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    ft = { "tex", "bib", "markdown" },
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require("luasnip-latex-snippets").setup({ use_treesitter = true })
      require("luasnip").config.setup({ enable_autosnippets = true })
    end,
  },
}
