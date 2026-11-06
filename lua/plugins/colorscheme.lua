return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	opts = {
		flavour = "auto", -- from 'background', through the map below
		background = { light = "latte", dark = "mocha" },
		transparent_background = require("config.settings").transparent_background,
		show_end_of_buffer = false,
		-- auto_integrations (default) detects installed plugins; only opt-outs here.
		integrations = {
			indent_blankline = { enabled = false },
			neogit = false,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme(require("config.settings").colorscheme)
	end,
}
