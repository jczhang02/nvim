local null_ls = require("null-ls")
local btns = null_ls.builtins

return {
	sources = {
		btns.formatting.clang_format.with({
			filetypes = { "c", "cpp" },
			extra_args = { "-style={BasedOnStyle: LLVM, IndentWidth: 2}" },
		}),
		require("user.configs.formatters.bibtex-tidy"),
		require("user.configs.formatters.xmlformat"),
	},
}
