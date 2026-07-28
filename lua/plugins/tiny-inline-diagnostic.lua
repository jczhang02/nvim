return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "modern",
				options = {
					show_source = true,
					multilines = { enabled = true, always_show = false },
					show_all_diags_on_cursorline = false,
				},
			})
		end,
	},
}
