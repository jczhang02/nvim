-- ~/.config/nvim-new/lua/plugins/gitsigns.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(m, l, r, d) vim.keymap.set(m, l, r, { buffer = buf, desc = d }) end
        map("n", "]h", function() if vim.wo.diff then vim.cmd.normal({"]c", bang=true}) else gs.nav_hunk("next") end end, "Next hunk")
        map("n", "[h", function() if vim.wo.diff then vim.cmd.normal({"[c", bang=true}) else gs.nav_hunk("prev") end end, "Prev hunk")
        map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>",   "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>",   "Reset hunk")
        map("n", "<leader>ghp", gs.preview_hunk,                            "Preview hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis,                                "Diff this")
        map("n", "<leader>ghD", function() gs.diffthis("~") end,            "Diff against HEAD~")
      end,
    },
  },
}
