local border_style = require("config.settings").border_style

return {
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = { auto_resize_height = true, preview = { border = border_style } },
	},
}
