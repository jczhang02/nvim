return {
	{
		"olimorris/persisted.nvim",
		event = "VimEnter",
		cmd = "Persisted",
		opts = {
			autoload = false,
			use_git_branch = true,
			ignored_dirs = { "/tmp", "/var" },
		},
		keys = {
			{ "<leader>ps", "<cmd>Persisted save<CR>", desc = "Session save" },
			{ "<leader>pl", "<cmd>Persisted load_last<CR>", desc = "Session load last" },
			{ "<leader>pt", "<cmd>Persisted toggle<CR>", desc = "Session toggle" },
			{ "<leader>pd", "<cmd>Persisted delete<CR>", desc = "Session delete" },
		},
	},
}
