local added = {}
local conf = require("modules.added.config")

added["numToStr/Navigator.nvim"] = {
	opt = true,
	event = "InsertEnter",
	config = function()
		require("Navigator").setup()
		vim.keymap.set("n", "<C-h>", "<CMD>NavigatorLeft<CR>")
		vim.keymap.set("n", "<C-l>", "<CMD>NavigatorRight<CR>")
		vim.keymap.set("n", "<C-k>", "<CMD>NavigatorUp<CR>")
		vim.keymap.set("n", "<C-j>", "<CMD>NavigatorDown<CR>")
	end,
}
added["askfiy/nvim-picgo"] = {
	opt = true,
	ft = "markdown",
	config = function()
		require("nvim-picgo").setup()
	end,
}
added["lervag/vimtex"] = {
	-- opt = true,
	-- ft = { "tex", "bib" },
	config = conf.vimtex,
}
added["dccsillag/magma-nvim"] = {
	opt = true,
	ft = "python",
	run = ":UpdateRemotePlugins",
	config = conf.magma,
}
added["rose-pine/neovim"] = {
	opt = false,
	as = "rose-pine",
	config = conf.rosepine,
}
added["MortenStabenau/matlab-vim"] = {
	opt = true,
	ft = "matlab",
	config = function()
		vim.cmd([[let g:matlab_executable = '/usr/bin/matlab']])
		vim.cmd([[let g:matlab_panel_size = 50]])
		vim.cmd([[let g:matlab_auto_start = 0]])
	end,
}
added["molleweide/LuaSnip-snippets.nvim"] = {
	opt = true,
	after = "LuaSnip",
}
added["ludovicchabant/vim-gutentags"] = {
	opt = true,
	ft = "tex",
	config = function()
		vim.g.gutentags_generate_on_new = 1
		vim.g.gutentags_generate_on_write = 1
		vim.g.gutentags_generate_on_missing = 1
		vim.g.gutentags_generate_on_empty_buffer = 0
		vim.g.gutentags_ctags_tagfile = ".tags"
	end,
}
added["machakann/vim-sandwich"] = {
	opt = true,
	event = "InsertEnter",
}
added["lewis6991/impatient.nvim"] = {
	opt = false,
}
added["iurimateus/luasnip-latex-snippets.nvim"] = {
	-- commit = "08c5b0e6079819a86082d16abadc2a16b800175c",
	config = function()
		vim.cmd([[packadd LuaSnip]])
		vim.cmd([[packadd vimtex]])
		require("luasnip-latex-snippets").setup()
		-- or setup({ use_treesitter = true })
	end,
	ft = "tex",
}
added["ii14/emmylua-nvim"] = {
	opt = true,
}
added["ekiim/vim-mathpix"] = {
	opt = true,
	ft = "tex",
}
return added
