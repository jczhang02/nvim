return {
	{
		-- Gives lua_ls the Neovim API and only the plugins a file requires, instead of
		-- indexing the whole runtimepath.
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
}
