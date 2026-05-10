return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>",          desc = "Explorer" },
    { "<C-n>",     "<cmd>Neotree toggle<CR>",          desc = "Explorer toggle" },
    { "<leader>fE", "<cmd>Neotree reveal<CR>",         desc = "Explorer reveal" },
    { "<leader>ge", "<cmd>Neotree git_status<CR>",     desc = "Git status (neo-tree)" },
    { "<leader>be", "<cmd>Neotree buffers<CR>",        desc = "Buffers (neo-tree)" },
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    popup_border_style = "rounded",
    sources = { "filesystem", "buffers", "git_status" },
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem",  display_name = " 󰉓 Files " },
        { source = "buffers",     display_name = " 󰈚 Bufs " },
        { source = "git_status",  display_name = " 󰊢 Git " },
      },
    },
    default_component_configs = {
      indent = { with_markers = true, indent_marker = "│", last_indent_marker = "└" },
      git_status = {
        symbols = {
          added = "", modified = "", deleted = "✖", renamed = "󰁕",
          untracked = "", ignored = "", unstaged = "󰄱", staged = "", conflict = "",
        },
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none",
        ["o"]       = "open",
        ["l"]       = "open",
        ["h"]       = "close_node",
        ["P"]       = { "toggle_preview", config = { use_float = true } },
        ["Y"]       = "copy_to_clipboard",
        ["<C-v>"]   = "open_vsplit",
        ["<C-x>"]   = "open_split",
      },
    },
    filesystem = {
      follow_current_file = { enabled = true, leave_dirs_open = false },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".git", "node_modules" },
      },
    },
    buffers = {
      follow_current_file = { enabled = true },
      group_empty_dirs = true,
    },
    git_status = {
      window = { position = "float" },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function() vim.cmd("setlocal relativenumber") end,
      },
    },
  },
}
