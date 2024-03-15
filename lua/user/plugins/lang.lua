local lang = {}

lang["lervag/vimtex"] = {
	lazy = false,
	config = require("configs.lang.vimtex"),
}

lang["MortenStabenau/matlab-vim"] = {
	lazy = true,
	ft = "matlab",
	config = require("configs.lang.matlab"),
}

lang["folke/neodev.nvim"] = {
	lazy = true,
	ft = { "lua" },
}

lang["jamespeapen/Nvim-R"] = {
	lazy = true,
	ft = { "r", "rmd", "quarto" },
	config = require("configs.lang.nvim-r"),
}

lang["microsoft/python-type-stubs"] = {
	lazy = true,
}

lang["gentoo/gentoo-syntax"] = {
	lazy = true,
	ft = { "ebuild" },
}

lang["theRealCarneiro/hyprland-vim-syntax"] = {
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	ft = "hypr",
}

return lang
