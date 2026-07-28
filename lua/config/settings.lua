local M = {}

M.format_on_save = true
M.format_timeout_ms = 1000
M.formatter_block_list = {}
M.format_disabled_dirs = {}
M.server_formatting_block_list = { clangd = true, lua_ls = true, ts_ls = true }

M.colorscheme = "catppuccin-latte"
M.background = "light"
M.transparent_background = false
M.border_style = "single"

M.lsp_inlayhints = false
M.lsp_servers = { "bashls", "clangd", "gopls", "html", "jsonls", "lua_ls", "pyright", "ruff", "ts_ls" }
M.mason_dap_adapters = { "codelldb" }
M.treesitter_parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"go",
	"gomod",
	"html",
	"javascript",
	"json",
	"latex",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"regex",
	"rust",
	"typescript",
	"vimdoc",
	"vue",
	"yaml",
}

return M
