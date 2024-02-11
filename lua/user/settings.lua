-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- Examples
settings["use_ssh"] = true
settings["use_copilot"] = false
settings["colorscheme"] = "catppuccin-latte"
settings["background"] = "light"
settings["server_formatting_block_list"] = {
	lua_ls = true,
	tsserver = true,
	clangd = true,
	texlab = true,
}

settings["null_ls_deps"] = {
	"clang_format",
	"prettier",
	"shfmt",
	"stylua",
	"vint",
	"latexindent",
	"beautysh",
}

settings["lsp_deps"] = function(defaults)
	return {
		"bashls",
		"clangd",
		"html",
		"jsonls",
		"lua_ls",
		"pyright",
		-- "pylsp",
	}
end

settings["disabled_plugins"] = {
	-- "jczhang02/luasnips-mathtex-snippets",
}

settings["gui_config"] = {
	font_name = "Iosevka NFP",
	font_size = 11,
}

return settings
