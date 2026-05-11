local M = {}

M.format_on_save = true
M.format_timeout = 1000
M.format_notify = true
M.format_modifications_only = false
M.formatter_block_list = { lua = false }
M.server_formatting_block_list = { clangd = true, lua_ls = true, ruff = false, ts_ls = true }
M.format_disabled_dirs = { "~/format_disabled_dir" }

M.diagnostics_virtual_lines = true
M.diagnostics_level = "HINT"

M.disabled_plugins = {}

M.colorscheme = "catppuccin-latte"
M.background = "light"
M.transparent_background = false

M.lsp_inlayhints = false
M.lsp_deps = { "bashls", "clangd", "gopls", "html", "jsonls", "lua_ls", "pyright", "ruff", "ts_ls" }
M.dap_deps = { "codelldb", "delve", "python" }
M.treesitter_deps = {
  "bash", "c", "cpp", "css", "go", "gomod", "html", "javascript",
  "json", "latex", "lua", "make", "markdown", "markdown_inline",
  "python", "rust", "typescript", "vimdoc", "vue", "yaml",
}

M.gui_config = { font_name = "JetBrainsMono Nerd Font", font_size = 12 }
M.external_browser = "chrome-cli open"

return M
