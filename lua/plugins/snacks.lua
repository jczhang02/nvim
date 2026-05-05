-- ~/.config/nvim-new/lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile      = { enabled = true, notify = true, size = 1.5 * 1024 * 1024 },
    bufdelete    = { enabled = true },
    dashboard    = {
      enabled = true,
      preset = {
        header = table.concat({
          "   _   __                _         ",
          "  / | / /__  ____ _   __(_)___ ___ ",
          " /  |/ / _ \\/ __ \\ | / / / __ `__ \\",
          "/ /|  /  __/ /_/ / |/ / / / / / / /",
          "\\_/ |_/\\___/\\____/|___/_/_/ /_/ /_/",
        }, "\n"),
        keys = {
          { icon = " ", key = "f", desc = "Find file",    action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New file",     action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find text",    action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "p", desc = "Projects",     action = ":lua Snacks.picker.projects()" },
          { icon = " ", key = "c", desc = "Config",       action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
          { icon = " ", key = "s", desc = "Restore session", action = ":SessionLoadLast" },
          { icon = "󰒲 ", key = "L", desc = "Lazy",         action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit",         action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps",      section = "keys",         indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects",     section = "projects",     indent = 2, padding = 1 },
        function()
          local in_session = vim.fn.argc(-1) == 0 and vim.v.this_session ~= ""
          if in_session then
            return { icon = " ", title = "Sessions", section = "sessions", indent = 2, padding = 1 }
          end
        end,
        { section = "startup" },
      },
    },
    explorer     = { enabled = true, replace_netrw = true },
    indent       = { enabled = true, scope = { enabled = true } },
    input        = { enabled = true },
    notifier     = { enabled = true, timeout = 3000, style = "compact" },
    picker       = {
      enabled = true,
      ui_select = true,
      sources = {
        files     = { hidden = true, ignored = false },
        grep      = { hidden = true },
        explorer  = { hidden = true },
      },
      win = {
        input = {
          keys = {
            ["<C-n>"] = { "list_down", mode = { "i", "n" } },
            ["<C-p>"] = { "list_up",   mode = { "i", "n" } },
          },
        },
      },
    },
    quickfile    = { enabled = true },
    scope        = { enabled = true },
    scratch      = { enabled = true },
    statuscolumn = { enabled = true },
    terminal     = { enabled = true },
    words        = { enabled = true, debounce = 200 },
  },
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end,                  desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end,                   desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end,                desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent() end,                 desc = "Recent files" },
    { "<leader>fc", function() Snacks.picker.command_history() end,        desc = "Command history" },
    { "<leader>fh", function() Snacks.picker.help() end,                   desc = "Help tags" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end,            desc = "LSP symbols (buffer)" },
    { "<leader>fw", function() Snacks.picker.lsp_workspace_symbols() end,  desc = "LSP symbols (workspace)" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end,            desc = "Diagnostics" },
    { "<leader>fu", function() Snacks.picker.undo() end,                   desc = "Undo tree" },
    { "<leader>fp", function() Snacks.picker.projects() end,               desc = "Projects" },
    { "<leader>fk", function() Snacks.picker.keymaps() end,                desc = "Keymaps" },
    { "<leader>e",  function() Snacks.explorer() end,                      desc = "Explorer" },
    { "<C-\\>",     function() Snacks.terminal.toggle() end,               mode = { "n", "t" }, desc = "Terminal toggle" },
    { "<leader>bd", function() Snacks.bufdelete() end,                     desc = "Delete buffer" },
    { "<leader>bD", function() Snacks.bufdelete.other() end,               desc = "Delete other buffers" },
    { "<leader>n.", function() Snacks.scratch() end,                       desc = "Scratch" },
    { "<leader>nh", function() Snacks.notifier.show_history() end,         desc = "Notification history" },
    { "<leader>nd", function() Snacks.notifier.hide() end,                 desc = "Dismiss notifications" },
  },
}
