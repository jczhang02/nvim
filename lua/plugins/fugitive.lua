return {
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gedit" },
		keys = {
			{ "<leader>gB", "<cmd>Git blame<CR>", desc = "Git blame" },
			{ "<leader>gP", "<cmd>Git push<CR>", desc = "Git push" },
			{ "<leader>gg", "<cmd>Git<CR>", desc = "Git status (stage, commit)" },
		},
	},
}
