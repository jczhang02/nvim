-- ~/.config/nvim-new/lua/plugins/asyncrun.lua
return {
  {
    "skywind3000/asyncrun.vim",
    cmd = { "AsyncRun", "AsyncStop" },
    dependencies = {
      { "preservim/vimux" },
    },
    init = function()
      vim.g.asyncrun_open = 8
      vim.g.asyncrun_bell = 1
    end,
    keys = {
      { "<leader>ar", ":AsyncRun ", desc = "AsyncRun (prompt)" },
    },
  },
  {
    "skywind3000/asynctasks.vim",
    cmd = { "AsyncTask", "AsyncTaskList", "AsyncTaskEdit", "AsyncTaskMacro", "AsyncTaskProfile" },
    dependencies = { "skywind3000/asyncrun.vim" },
    init = function()
      vim.g.asynctasks_term_pos = "bottom"
      vim.g.asynctasks_term_rows = 10
    end,
    keys = {
      { "<leader>at", "<cmd>AsyncTaskList<CR>", desc = "Task list" },
      { "<leader>ae", "<cmd>AsyncTaskEdit<CR>", desc = "Task edit" },
    },
  },
}
