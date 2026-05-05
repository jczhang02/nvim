-- ~/.config/nvim-new/lua/plugins/pastify.lua
return {
  {
    "TobinPalmer/pastify.nvim",
    cmd = { "Pastify" },
    keys = {
      { "<leader>pi", "<cmd>Pastify<CR>", desc = "Pastify image" },
    },
    opts = {
      opts = { absolute_path = false, apikey = "", local_path = "/figures",
        ft = {
          html     = '<img src="$IMG$" alt="">',
          markdown = "![]($IMG$)",
          tex      = [[\includegraphics[width=\linewidth]{$IMG$}]],
        },
      },
      save = "local",
    },
  },
}
