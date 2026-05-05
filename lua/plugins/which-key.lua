-- ~/.config/nvim-new/lua/plugins/which-key.lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      icons = { mappings = false },
      spec = {
        { "<leader>f", group = "find/picker" },
        { "<leader>l", group = "lsp" },
        { "<leader>lp", group = "peek (glance)" },
        { "<leader>d", group = "dap/debug" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "git hunk" },
        { "<leader>b", group = "buffer" },
        { "<leader>w", group = "window" },
        { "<leader>W", group = "window swap" },
        { "<leader>t", group = "terminal/tab" },
        { "<leader>x", group = "trouble/quickfix" },
        { "<leader>s", group = "session (legacy)" },
        { "<leader>S", group = "search & replace (grug-far)" },
        { "<leader>c", group = "code" },
        { "<leader>r", group = "refactor/rename" },
        { "<leader>n", group = "notify/scratch" },
        { "<leader>p", group = "persisted" },
        { "<leader>P", group = "package (lazy)" },
        { "<leader>a", group = "asyncrun/asynctasks" },
        { "<leader>h", group = "profile (plenary)" },
        { "<leader>j", group = "jump (flash)" },
        { "<leader>z", group = "treesitter swap" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
}
